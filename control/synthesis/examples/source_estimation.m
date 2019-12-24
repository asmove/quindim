function xhat = source_estimation(t, q_p, xhat_0, nu, sigma, lambda, ...
                                   oracle,  T, sensor_reading, sys)
    persistent m_1 xhat_ t_curr t_0 t_s xhat_s m_s;
    persistent t_readings readings counter;
    persistent t_estimations estimations;
    
    % Variables initialization
    if(isempty(t_0))
        t_0 = [];
    end

    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(xhat_s))
        xhat_s = xhat_0';
        assignin('base', 'xhat_s', []);
    end
    
    if(isempty(t_0))
        t_0 = t;
    end
    
    if(isempty(t_curr))
        t_prev = t;
    end
    
    if(isempty(t_estimations))
        t_estimations = t;
    end
    
    if(isempty(m_1))
        m_1 = 0;
    end

    if(isempty(t_s))
        t_s = [];
        assignin('base', 't_s', []);
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
                                      
        m_1 = m;
        xhat_ = xhat;
        m_s = [m_s; m];

        t_readings = [];
        readings = [];
        
        m_s = [];
        
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
        if(counter == 1)
            t_0 = t;

            % New prediction
            [xhat, m] = expbary(oracle, xhat_s, nu);
            
            xhat_s = [xhat_s; xhat];

            n_iterations = 1;
            [xhat, ~, m] = drecexpbary_custom(oracle, m, xhat, ...
                                              nu, sigma, lambda, ...
                                              n_iterations);
            
            xhat_s = [xhat_s; xhat];
            
            % Update previous and current values
            xhat_ = xhat';
            
            t_estimations = [t_estimations; t];
            estimations = [estimations; xhat_'];
            
            assignin('base', 't_estimations', t_estimations);
            assignin('base', 'estimations', estimations);
        else
            xhat = xhat_;
        end
    end
    
    % Update readings during excursion
    if(counter == 1)
        q_p_s = [sys.kin.q; sys.kin.p{end}];
        x = subs(sensor_reading, q_p_s, q_p);
        
        reading = oracle(x);
        
        % Simulation time
        t_s = [t_s; t];
        
        % Readings over trajectory
        xhat_s = double([xhat_s; x']);
        
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