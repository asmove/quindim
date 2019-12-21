function [xhat, xhat_1] = source_estimation(t, q_p, xhat_0, ...
                                            nu, sigma, lambda, ...
                                            oracle,  T, ...
                                            sensor_reading, sys)
    persistent m_1 xhat_1_ xhat_ t_curr t_0 t_s xhat_s m_s xhat_t;
    persistent t_estimations estimations;
    persistent t_readings readings counter;
    
    % Variables initialization
    if(isempty(t_0))
        t_0 = [];
    end

    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(xhat_s))
        xhat_s = xhat_0;
        assignin('base', 'xhat_s', []);
    end
    
    if(isempty(t_0))
        t_0 = t;
    end
    
    if(isempty(t_curr))
        t_prev = t;
    end
    
    if(isempty(m_1))
        m_1 = 0;
    end

    if(isempty(t_s))
        t_s = [];
        assignin('base', 't_s', []);
    end
    
    if(isempty(xhat_s))
        xhat_s = [];
        assignin('base', 'xhat_s', []);
    end
    
    if(isempty(xhat_t))
        xhat_t = [];
        assignin('base', 'xhat_t', []);
    end
    
    if(isempty(estimations))
        estimations = [];
        assignin('base', 'estimations', []);
    end
    
    if(isempty(t_estimations))
        t_estimations = [];
        assignin('base', 't_estimations', []);
    end
    
    if(isempty(readings))
        readings = [];
        assignin('base', 'readings', []);
    end
    
    if(isempty(t_readings))
        t_readings = [];
        assignin('base', 't_readings', []);
    end
    
    if(isempty(m_s))
        m_s = [];
        assignin('base', 'm_s', []);
    end
    
    % Special: First assignment of barycenter
    if(isempty(xhat_1_))
        xhat_1_ = xhat_0;
        xhat_1 = xhat_0;
        
        [xhat, ~, m] = drecexpbary_custom(oracle, 0, xhat_0, ...
                                          nu, sigma, lambda, 1);
                                      
        m_1 = m;
        xhat_ = xhat;
        m_s = [m_s; m];
                
        t_estimations = t;
        estimations = xhat;

        t_readings = [];
        readings = [];
        
        m_s = [];
    end
    
    % Current state
    t_curr = t;
    
    counter = counter + 1;
    
    % Update source estimation window
    if(t_curr > t_0 + T)
        if(counter == 1)
            t_0 = t;
            
            % New prediction
            [xhat, m] = expbary(oracle, xhat_s, nu);
            m_1 = m + m_1;
            
%             n_iterations = 1;
%             [xhat, ~, m] = drecexpbary_custom(oracle, m_1, xhat, ...
%                                               nu, sigma, lambda, ...
%                                               n_iterations);
            m_1 = m + m_1;
            
%             % Absorb barycenter records
%             xhat_s = [];

            % Update previous and current values
            xhat_1_ = xhat_;
            xhat_ = xhat;
            m_s = double([m_s; m_1]);
            
            xhat_1 = xhat;
        end
    % Constant value on window
    else
        xhat = xhat_;
        xhat_1 = xhat_1_;
    end
    
    % Update readings during excursion
    if(counter == 1)
        q_p_s = [sys.kin.q; sys.kin.p{end}];
        x = subs(sensor_reading, q_p_s, q_p);
        
        reading = oracle(x);
    
        % Readings over trajectory
        xhat_s = double([xhat_s; x']);
        
        % Simulation time
        t_s = [t_s; t];
        
        % Source estimation
        xhat_t = [xhat_t; xhat_];
        
        % Sensor readings
        t_readings = [t_readings; t];
        readings = double([readings; reading]);
        
        assignin('base', 'xhat_t', xhat_t);
        assignin('base', 't_s', t_s);
        assignin('base', 'xhat_s', xhat_s);
        assignin('base', 't_readings', t_readings);
        assignin('base', 'readings', readings);
    end
    
    % Counter update
    if(counter == 4)
        counter = 0;
    end
    
    xhat = xhat_';
    xhat_1 = xhat_1_';
end