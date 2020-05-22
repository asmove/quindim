function xhat = source_estimation(t, q_p, sestimation_info, sys)
    persistent xhat_ t_0 t_s t_xhat xhat_acc xhat_s xs_curr;
    persistent t_readings readings counter is_T;
    persistent t_estimations estimations;
    
    % Estimation structure unwrap
    xhat_0 = sestimation_info.xhat_0;
    nu = sestimation_info.nu;
    sigma = sestimation_info.sigma;
    lambda = sestimation_info.lambda;
    oracle = sestimation_info.oracle;
    T_curr = sestimation_info.T_cur;
    source_reference = sestimation_info.source_reference;
    
    if(isempty(xs_curr))
        states = [sys.kin.q; sys.kin.p{end}];
        xs_curr = subs(source_reference.', states, q_p);
    end
    
    % Variables initialization
    
    % Integration algorithm counter
    if(isempty(counter))
        counter = 0;
    end
    
    % Threshold init
    if(isempty(is_T))
        is_T = false;
    end
    
    % Symbolic xhat
    if(isempty(xhat_s))
        xhat_s = xhat_0';
        assignin('base', 'xhat_s', []);
    end
    
    % Accumulated estimation vector
    if(isempty(xhat_acc))
        xhat_acc = xhat_0';
        assignin('base', 'xhat_acc', xhat_acc);
    end
    
    % Initial instant of comparisson with time interval
    if(isempty(t_0))
        t_0 = t;
        assignin('base', 't_0', t_0);
    end
    
    if(isempty(t_estimations))
        t_estimations = t;
        assignin('base', 't_estimations', t_estimations);
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
    
    % Special: First assignment of barycenter
    if(isempty(xhat_))
        m0 = 0;
        accel_fun = @(m_1, x_1, delta_xhat_1) zeros(size(x_1));
        [xhat, ~, ~] = drecexpbary_custom(oracle, m0, ...
                                          xhat_0, nu, sigma, ...
                                          lambda, accel_fun);
                                      
        xhat_ = xhat;
        
        xhat_acc = [xhat_acc; xhat'];
        
        t_estimations = [t_estimations; t];
        estimations = [estimations; xhat_'];
        
        assignin('base', 't_estimations', t_estimations);
        assignin('base', 'estimations', estimations);

    end
    
    if(isempty(estimations))
        estimations = xhat';
    end
    
    % Current state
    counter = counter + 1;
    
    % Update source estimation window
    if(t >= t_0 + T_curr)
        
        % Quick hack: Avoid multiple reads of runge-kutta algorithm
        is_T = true;
        if(is_T)
            t_0 = t;

            % New prediction
            [xhat, m] = expbary(oracle, xs_curr, nu);
            
            n_iterations = 1;
            [xhat, ~, m] = drecexpbary_custom(oracle, m, xhat, ...
                                              nu, sigma, lambda, ...
                                              n_iterations);
            
            x_curr = subs(source_reference.', ...
                          [sys.kin.q; sys.kin.p{end}], q_p);
            
            xhat_acc = [xhat_acc; xhat];
            xs_curr = [xs_curr; x_curr];
            t_xhat = [t_xhat; t];
            xhat_s = [xhat_s; xhat];
            xhat_ = xhat';            
            t_estimations = [t_estimations; t];
            estimations = [estimations; xhat_'];
            
            assignin('base', 't_xhat', t_estimations);
            assignin('base', 'xhat_s', xhat_s);
            assignin('base', 'xhat_acc', xhat_acc);
            assignin('base', 't_estimations', t_estimations);
            assignin('base', 'estimations', estimations);
            
            is_T = false;
        else
            xhat = xhat_;
        end
    else
        xhat = xhat_;
    end
    
    x_curr = subs(source_reference.', ...
                  [sys.kin.q; sys.kin.p{end}], q_p);
    xs_curr = [xs_curr; x_curr];
    
    % Update readings during excursion
    if(counter == 1)
        q_p_s = [sys.kin.q; sys.kin.p{end}];
        x = subs(source_reference, q_p_s, q_p);
        
        reading = oracle(x);
        
        % Simulation time
        t_s = [t_s; t];
        
        % Sensor readings
        t_readings = [t_readings; t];
        readings = double([readings; reading]);        
        
        assignin('base', 't_s', t_s);
        assignin('base', 'xhat_s', xhat_s);
        assignin('base', 'xs_curr', xs_curr);
        assignin('base', 't_readings', t_readings);
        assignin('base', 'readings', readings);
    end
    
    xhat = vpa(xhat);
    
    % Counter update
    if(counter == 4)
        counter = 0;
    end
    
    xhat = xhat_;
end