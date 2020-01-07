function u = ljapunov_based(t, q_p, xhat, xhat_0, P, zeta, eta, ...
                            T, degree_G, W, source_reference, sys)
    persistent u_control tu_s u_s counter ...
               phat_t xhat_t pphat_t xphat_t;
    persistent xhat_1 phat_1 xhat_ phat_ t_0 t_curr;
    persistent u_parts phat_sym xphat_sym pphat_sym;
    persistent remaining_source_states source_states;
    
    p = sys.kin.p{end};
    q = sys.kin.q;
    C = sys.kin.C;
    
    xhat_s = sym('xhat_', size(source_reference));
    p_hat_s = sym('phat_', size(p));
    xp_hat_s = sym('xphat_', size(source_reference));
    xpp_hat_s = sym('xpphat_', size(source_reference));
    pp_hat_s = sym('pphat_', size(p));
    
    if(isempty(source_states))
        vars_reference = symvar(source_reference);
        is_state = ismember(vars_reference, q); 
        states_reference = vars_reference(is_state);

        is_reference_state = ismember(q, states_reference);
        remaining_source_states = q(~is_reference_state);

        source_states = states_reference.';
    end
    
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
        u_control = control_calc(sys, P, degree_G, W, eta, source_reference);
        assignin('base', 'u_control', u_control);
    end
    
    is_positive(P);
    
    if(zeta <= 0)
        error('Zeta MUST be greater than 0!');
    end
    
    % Time for periodic variables
    t_curr = t;
    
    % Smoothed xhat
    n_xhat = length(xhat);
        
    counter = counter + 1;
    % Avoid runge-kutta repetitions
    if(counter == 1)        
        if(t_curr >= t_0 + T)            
            t_0 = t;
            
            n = length(q);
            m = length(p);

            xhat_1 = xhat_;
            phat_1 = phat_;
            
            xhat_ = xhat;
            phat_ = phat;
        end
    end
    
    [xhat_traj, xphat_traj, xpphat_traj, phat_traj, pphat_traj] = ...
        generate_trajectory(t_curr, t_0, T, ...
                            xhat_1, xhat_, phat_1, phat_, sys);
    
    syms_params = [q.', p.', ...
                   xhat_s.', p_hat_s.', ...
                   xp_hat_s.', pp_hat_s.'];
               
    num_params = [q_p', ...
                  xhat_traj', phat_traj', ...
                  xphat_traj', pphat_traj'];
    
    L_f_v = vpa(subs(u_control.L_f_v, syms_params, num_params));
    L_G_v = vpa(subs(u_control.L_G_v, syms_params, num_params));
    Vp = vpa(subs(u_control.Vp, syms_params, num_params));
    W = vpa(subs(u_control.W, syms_params, num_params));
    n_G = vpa(subs(u_control.n_G, syms_params, num_params));
    
    b = vpa(L_G_v*W);
    c = vpa(b'/(b*b'));
    
    u = double((W*c)*(Vp - L_f_v));
    
    if(counter == 1)
        aux.L_f_v = L_f_v;
        aux.L_G_v = L_G_v;
        aux.Vp = Vp;
        
        u_parts = [u_parts; aux];
        u_s = [u_s; u'];
        tu_s = [tu_s; t];
        phat_t = [phat_t; phat_traj'];
        xhat_t = [xhat_t; xhat_traj'];
        pphat_t = [pphat_t; pphat_traj'];
        xphat_t = [xphat_t; xphat_traj'];
        
        assignin('base', 'u_parts', u_parts);
        assignin('base', 'xhat_t', xhat_t);
        assignin('base', 'phat_t', phat_t);
        assignin('base', 'xphat_t', xphat_t);
        assignin('base', 'pphat_t', pphat_t);
        assignin('base', 'u_s', u_s);
        assignin('base', 'tu_s', tu_s);
    end
    
    if(counter == 4)
        counter = 0;
    end
end