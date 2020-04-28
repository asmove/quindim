function xhat = source_estimation(t, q_p, sestimation_info, sys)
    persistent t_0 t_s t_xhat xhat_acc xhat_s;
    persistent t_readings readings counter is_T estimations;
    persistent m_prev xhat_prev m_interval xhat_interval;
    
    xhat_0 = sestimation_info.xhat_0;
    nu = sestimation_info.nu;
    sigma = sestimation_info.sigma;
    lambda = sestimation_info.lambda;
    oracle = sestimation_info.oracle;
    T = sestimation_info.T_cur;
    source_reference = sestimation_info.source_reference;
    
    [n, m] = size(sys.kin.C);
    
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
        m_interval = 0;
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
    
    if(isempty(t_readings))
        t_readings = [];
        assignin('base', 't_readings', []);
    end
    
    % First assignment of barycenter
    if(isempty(xhat_prev))
        m0 = 0;
        
       accel_fun = @(m_1, x_1, delta_xhat_1) ...
                     non_accel(m_1, x_1, delta_xhat_1);
        
        iterations = 1;
        [xhat, ~, ~, ms] = drecexpbary_custom(oracle, m0, xhat_0, nu, sigma, ...
                                          lambda, iterations, accel_fun);
        
        m_prev = ms(end);
                                      
        % Barycenter at initial instant
        xhat_prev = xhat;
        
        xhat_acc = [xhat_acc; xhat'];
        estimations = [estimations; xhat_prev'];
        
        assignin('base', 'xhat_acc', xhat_acc);
        assignin('base', 'estimations', estimations);
    end
    
    xhat = xhat_prev;
    
    % Current state
    counter = counter + 1;
    
    % Update source estimation window
    if(t >= t_0 + T)
        
        % Quick hack: Avoid multiple reads of runge-kutta algorithm
        is_T = true;
        if(is_T)
            t_0 = t;
            
            disp('-----> AQUI <-----');
            
            % Calculation of current barycenter under consideration of
            % exploration
            xhat_1_n = (m_interval*xhat_interval + m_prev*xhat_prev)/(m_interval + m_prev);
            m_1_n = m_interval + m_prev;
            
            accel_fun = @(m_1, x_1, delta_xhat_1) ...
                     non_accel(m_1, x_1, delta_xhat_1);            
            n_iterations = 1;
            
            [xhat_n, ~, ~, ms] = drecexpbary_custom(oracle, m_1_n, xhat_1_n, nu, sigma, ...
                                                    lambda, n_iterations, accel_fun);
                                          
            % Update previous and current values
            m_prev = ms(end);
            xhat_prev = xhat_n;
            
            % TAKE NOTE: zero xs_curr to reduce number of operations and storage
            xhat_curr = zeros(size(xhat_prev));
            m_curr = 0;
            
            x_curr = subs(source_reference.', [sys.kin.q; sys.kin.p{end}], q_p(1:end-1));
            
            % Source signal variables update
            t_xhat = [t_xhat; t];
            estimations = [estimations; xhat_prev'];
            
            assignin('base', 'xhat_s', xhat_s);
            assignin('base', 'estimations', estimations);
            
            is_T = false;
        else
            xhat = xhat_prev;
        end
    end
    
    [n, m] = size(sys.kin.C);
    
    q_p_t = q_p(1:n+m, 1);
    q_p_s = [sys.kin.q; sys.kin.p{end}];
    
    x_curr = subs(source_reference, q_p_s, q_p_t);
    
    xhat_curr = (m_interval*xhat_interval + x_curr*oracle(x_curr))/(m_interval + oracle(x_curr));
    m_curr = m_interval + oracle(x_curr);
    
    xhat = vpa(xhat);
    
    % Update readings during excursion
    if(counter == 1)
        x = subs(source_reference, q_p_s, q_p_t);
        
        reading = oracle(x);
        
        % Simulation time
        t_s = [t_s; t];
        
        % Sensor readings
        t_readings = [t_readings; t];
        readings = double([readings; reading]);        
        
        assignin('base', 't_s', t_s);
        assignin('base', 'xhat_s', xhat_s);
        
        assignin('base', 't_readings', t_readings);
        assignin('base', 'readings', readings);
    end
    
    % Counter update
    if(counter == 4)
        counter = 0;
    end
end