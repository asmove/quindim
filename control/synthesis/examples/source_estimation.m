function xhat = source_estimation(t, x, xhat_0, nu, sigma, lambda, ...
                                  oracle,  T, sensor_reading, sys)
    persistent m_1 xhat_1 t_curr t_0 t_s xhat_s oracles xhat_prev m_prev;
    
    % Variables initialization
    if(isempty(t_0))
        t_0 = [];
    end
    
    if(isempty(xhat_s))
        xhat_s = [];
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
    
    if(isempty(xhat_1))
        [xhat_1, ~] = drecexpbary_custom(oracle, 0, xhat_0, ...
                                         nu, sigma, lambda, 1);
    end

    if(isempty(xhat_1))
        oracles = oracle(xhat_0);
    end
    
    t_curr = t;
    
    if(t_curr > t_0 + T)
        [xhat, m] = expbary(oracle, xhat_s, nu);
        xhat_s = [];
        
        xhat = (xhat*m + xhat_1*m_1)/(m + m_1);
        
        xhat_1 = xhat;
        m_1 = m;
    else
        xhat = xhat_1;
    end
    
    q_p = [sys.kin.q; sys.kin.p{end}];
    x = subs(sensor_reading, q_p, x);
    
    xhat_s = [xhat_s; x'];
    oracles = [oracles; oracle(x)];
    t_s = [t_s, t];
    t_prev = t;
end