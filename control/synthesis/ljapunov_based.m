function u = ljapunov_based(t, q_p, xhat, ...
                            xhat_0, P, zeta, eta, T, ...
                            perc, degree, source_reference, sys)
    persistent u_control tu_s u_s counter phat_t xhat_t;
    persistent xhat_1 phat_1 xhat_ phat_ t_0 t_curr;
    persistent u_parts;
    
    if(isempty(xhat_t))
        xhat_t = [];
        assignin('base', 'xhat_t', xhat_t);
    end
    
    if(isempty(phat_t))
        phat_t = [];
        assignin('base', 'phat_t', phat_t);
    end

    if(isempty(xhat_1))
        xhat_1 = xhat_0;
    end
    
    if(isempty(phat_1))
        phat_1 = zeros(size(xhat_0));
    end
    
    if(isempty(xhat_))
        xhat_ = xhat;
    end
    
    delta_x = xhat - xhat_1;
    phat = zeta*delta_x;
    
    if(isempty(phat_))
        phat_ = phat;
    end
    
    if(isempty(t_0))
        t_0 = t;
    end
        
    if(isempty(t_curr))
        t_curr = t;
    end
    
    if(isempty(tu_s))
        tu_s = [];
        assignin('base', 'tu_s', tu_s);
    end
    
    if(isempty(u_s))
        u_s = [];
        assignin('base', 'u_s', u_s);
    end
    
    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(u_control))
        u_control = control_calc(sys, P, eta, source_reference);
        assignin('base', 'u_control', u_control);
    end
    
    is_positive(P);
    
    if(zeta <= 0)
        error('Zeta MUST be greater than 0!');
    end
    
    if((perc < 0)||(perc > 1))
        error('Percentage MUST be between 0 and 1!');
    end
    
    if(degree < 0)
        error('Degree MUST be greater or equal than 0!');
    end
        
    % Time for periodic variables
    t_curr = t;
    
    p = sys.kin.p{end};
    q = sys.kin.q;

    x = subs(source_reference, [q; p], q_p);
        
    xhat_s = sym('xhat_', size(x));
    p_hat_s = sym('phat_', size(p));
    xp_hat_s = sym('xphat_', size(x));
    pp_hat_s = sym('pphat_', size(p));
    
    % Smoothed xhat
    n_xhat = length(xhat);
    
    counter = counter + 1;
    % Avoid runge-kutta repetitions
    if(counter == 1)        
        if(t_curr >= t_0 + T)            
            t_0 = t;
            
            n = length(q);
            m = length(p);
            
            xhat_1 = subs(source_reference, q, q_p(1:n));
            phat_1 = q_p(n+1:end);
            
            delta_x = xhat - xhat_1;
            phat = zeta*delta_x;
            
            xhat_ = xhat;
            phat_ = phat;
        end
    end
        
    xhat_smoothed = zeros(size(xhat));
    for i = 1:n_xhat
        t_local = t_curr - t_0;
        perc_T = perc*T;
                
        xhat_smoothed(i) = smoothstep(t_local, perc_T, ...
                                      xhat_1(i), xhat_(i), degree);
    end
    
    % Smoothed phat
    phat_smoothed = zeros(size(phat));
    for i = 1:n_xhat
        t_local = t_curr - t_0;
        perc_T = perc*T;
        
        phat_smoothed(i) = smoothstep(t_local, perc_T, ...
                                      phat_1(i), phat_(i), degree);
    end
    
    % Smoothed xphat
    xphat_smoothed = zeros(size(xhat));
    for i = 1:n_xhat
        t_local = t_curr - t_0;
        perc_T = perc*T;
        
        xphat_smoothed(i) = ndsmoothstep(t_local, perc_T, ...
                                         xhat_1(i), xhat_(i), degree, 1);
    end
        
    % Smoothed pphat
    pphat_smoothed = zeros(size(phat));
    for i = 1:n_xhat
        t_local = t_curr - t_0;
        perc_T = perc*T;
        
        pphat_smoothed(i) = ndsmoothstep(t_local, perc_T, ...
                                         phat_1(i), phat_(i), degree, 1);
    end
    
    syms_params = [q.', p.', ...
                   xhat_s.', p_hat_s.', ...
                   xp_hat_s.', pp_hat_s.'];
               
    num_params = [q_p', ...
                  xhat_smoothed', phat_smoothed', ...
                  xphat_smoothed', pphat_smoothed'];
    
    L_f_v = double(subs(u_control.L_f_v, syms_params, num_params));
    L_G_v = double(subs(u_control.L_G_v, syms_params, num_params));
    Vp = double(subs(u_control.Vp, syms_params, num_params));
    u = double(L_G_v.'/norm(L_G_v)^2*(Vp - L_f_v));
    
    if(counter == 1)
        aux.L_f_v = L_f_v;
        aux.L_G_v = L_G_v;
        aux.Vp = Vp;
        
        u_parts = [u_parts; aux];
        
        u_s = [u_s; u'];
        tu_s = [tu_s; t];
        phat_t = [phat_t; phat_smoothed'];
        xhat_t = [xhat_t; xhat_smoothed'];
        
        assignin('base', 'u_parts', u_parts);
        assignin('base', 'xhat_t', xhat_t);
        assignin('base', 'phat_t', phat_t);        
        assignin('base', 'u_s', u_s);
        assignin('base', 'tu_s', tu_s);
    end
    
    if(counter == 4)
        counter = 0;
    end
end