function [xhat, save_states] = source_estimation(t, q_p, sestimation_info, sys)
    persistent t_0 t_s t_xhat xhat_acc xhat_s xhat_intervals;
    persistent t_readings readings counter is_T estimations;
    persistent xhat_prev m_interval xhat_interval;
    
    t0 =  tic();
    
    accel_fun = @(m_1, x_1, delta_xhat_1) ...
                     non_accel(m_1, x_1, delta_xhat_1);
    
    xhat_0 = sestimation_info.xhat_0;
    nu = sestimation_info.nu;
    sigma = sestimation_info.sigma;
    lambda = sestimation_info.lambda;
    oracle = sestimation_info.oracle;
    T = sestimation_info.T_cur;
    source_reference = sestimation_info.source_reference;
    
    % Variables initialization
    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(is_T))
        is_T = false;
    end
    
    if(isempty(xhat_interval))
        xhat_interval = xhat_0;
    end
    
    if(isempty(m_interval))
        m_interval = exp(-nu*oracle(xhat_interval));
    end
    
    if(isempty(xhat_s))
        xhat_s = xhat_0';
        assignin('base', 'xhat_s', []);
    end
    
    if(isempty(xhat_acc))
        xhat_acc = xhat_0';
        assignin('base', 'xhat_acc', xhat_acc);
    end
    
    if(isempty(t_0))
        t_0 = t;
        assignin('base', 't_0', t_0);
    end

    if(isempty(t_s))
        t_s = t;
        assignin('base', 't_s', t_s);
    end
    
    if(isempty(t_xhat))
        t_xhat = t;
        assignin('base', 't_xhat', t_xhat);
    end
    
    if(isempty(readings))
        readings = [];
        assignin('base', 'readings', []);
    end
    
    if(isempty(xhat_intervals))
        xhat_intervals = [];
    end
    
    if(isempty(t_readings))
        t_readings = [];
        assignin('base', 't_readings', []);
    end
    
    % First assignment of barycenter
    if(isempty(xhat_prev))
        n = length(xhat_0);
        z = zeros(n, 1);
        for i = 1:n
            z(i) = gaussianrnd(0, sigma); 
        end
        
        xhat = xhat_0 + z;
        xhat_prev = xhat;
                                         
        xhat_acc = [xhat_acc; xhat'];
        estimations = [estimations; xhat_prev'];
        
        assignin('base', 'xhat_acc', xhat_acc);
        assignin('base', 'estimations', estimations);
    end
    
    toc(t0);
    
    % Current state
    counter = counter + 1;
    
    % Update source estimation window
    if(t - t_0 >= T)
        
        % Quick hack: Avoid multiple reads of runge-kutta algorithm
        is_T = true;
        if(is_T)
            t_0 = t;
            
            msg = 't = %.4f, xhat_prev = (%.4f, %.4f)\n';
            fprintf(msg, t, xhat_interval(1), xhat_interval(2));
            
            n = length(xhat_0);
            z = zeros(n, 1);
            for i = 1:n
                z(i) = gaussianrnd(0, sigma); 
            end
            
            xhat = xhat_interval + z;
            
            msg = 't = %.4f, xhat_prev = (%.4f, %.4f)\n';
            fprintf(msg, t, xhat(1), xhat(2));
            
            % TAKE NOTE: zero xs_curr to reduce number of operations and storage
            xhat_curr = zeros(size(xhat_prev));
            x_curr = subs(source_reference, [sys.kin.q; sys.kin.p{end}], q_p(1:end-1));            
            
            e_i = exp(-nu*oracle(xhat_curr));
            xhat_prev = (xhat_interval*m_interval + x_curr*e_i)/(e_i + m_interval);
            
            m_interval = exp(-nu*oracle(xhat_interval));
            
            % Source signal variables update
            t_xhat = [t_xhat; t];
            estimations = [estimations; xhat_prev'];
            
            assignin('base', 'xhat_s', xhat_s);
            assignin('base', 'estimations', estimations);
            
            save_states = is_T;
            is_T = false;
        end
    else
        xhat = xhat_prev;
        save_states = is_T;
    end
    
    t0 = tic();
    
    [n, m] = size(sys.kin.C);
    
    q_p_t = q_p(1:n+m, 1);
    q_p_s = [sys.kin.q; sys.kin.p{end}];
    
    x_curr = subs(source_reference, q_p_s, q_p_t);
    
    m_1 = m_interval;
    e_i = exp(-nu*oracle(x_curr));
    
    xhat_interval = (m_interval*xhat_interval + x_curr*e_i)/(m_interval + e_i);
    m_interval = m_interval + e_i;
    xhat_interval = vpa(xhat_interval);
    
    toc(t0)
    
    t0 = tic();
    disp('-----------------------------------');
    msg = 't = %.4f, m_hat = %.5f; m_1 = %.5f; xhat = (%.4f, %.4f)\n';
    fprintf(msg, t, m_interval, m_1, xhat_interval(1), xhat_interval(2));
    
    toc(t0)
    
    t0 = tic();
    % Update readings during excursion
    if(counter == 1)
        x = subs(source_reference, q_p_s, q_p_t);
        
        reading = oracle(x);
        
        % Simulation time
        t_s = [t_s; t];
        
        % Sensor readings
        t_readings = [t_readings; t];
        readings = double([readings; reading]);        
        xhat_intervals = [xhat_intervals; xhat_interval'];
        
        assignin('base', 't_s', t_s);
        assignin('base', 'xhat_s', xhat_s);
        assignin('base', 'xhat_current', xhat_intervals);
        
        assignin('base', 't_readings', t_readings);
        assignin('base', 'readings', readings);
    end
    
    % Counter update
    if(counter == 4)
        counter = 0;
    end
    toc(t0)
end