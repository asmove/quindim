function xhat = source_estimation(t, q_p, xhat_0, nu, sigma, lambda, ...
                                   oracle,  T, source_reference, sys)
    persistent xhat_ t_curr t_0 t_s t_xhat xhat_acc xhat_s xs_curr;
    persistent t_readings readings counter is_T;
    persistent t_estimations estimations;
    
    if(isempty(xs_curr))
        states = [sys.kin.q; sys.kin.p{end}];
        xs_curr = subs(source_reference.', states, q_p);
    end
    
    % Variables initialization
    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(is_T))
        is_T = false;
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
    
    if(isempty(t_curr))
        t_curr = t;
        assignin('base', 't_curr', t_curr);
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
        [xhat, ~, m] = drecexpbary_custom(oracle, 0, xhat_0, ...
                                          nu, sigma, lambda, 1);
                                      
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
    t_curr = t;
    counter = counter + 1;
    
    % Update source estimation window
    if(t_curr >= t_0 + T)
        
        % Quick hack: Avoid multiple reads of runge-kutta algorithm
        is_T = true;
        if(is_T)
            t_0 = t;

            % New prediction
            [xhat, m] = expbary(oracle, xhat_acc, nu);
            
            xhat_acc = [xhat_acc; xhat];
            
            n_iterations = 1;
            [xhat, ~, m] = drecexpbary_custom(oracle, m, xhat, ...
                                              nu, sigma, lambda, ...
                                              n_iterations);
            
            
            xhat_acc = [xhat_acc; xhat];
            
            x_curr = subs(source_reference.', ...
                          [sys.kin.q; sys.kin.p{end}], q_p);
            xs_curr = [xs_curr; x_curr];            
                                          
            t_xhat = [t_xhat; t];
            xhat_s = [xhat_s; xhat];
            
            % Update previous and current values
            xhat_ = xhat';
            
            t_estimations = [t_estimations; t];
            estimations = [estimations; xhat_'];
            
            assignin('base', 't_xhat', t_estimations);
            assignin('base', 'xhat_s', xhat_s);
            
            assignin('base', 'xhat_acc', xhat_acc);
            
            assignin('base', 'xs_curr', xs_curr);
            
            assignin('base', 't_estimations', t_estimations);
            assignin('base', 'estimations', estimations);
            
            is_T = false;
        else
            xhat = xhat_;
        end
    else
        xhat = xhat_;
    end
    
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
        assignin('base', 't_readings', t_readings);
        assignin('base', 'readings', readings);
    end
    
    % Counter update
    if(counter == 4)
        counter = 0;
    end
    
    xhat = xhat_;
end