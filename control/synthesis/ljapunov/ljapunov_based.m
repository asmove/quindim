function u = run_cotrol_law(t, q_p, xhat, xhat_0, P, zeta, eta, ...
                            T_cur, T_traj, dt, W, source_reference, ...
                            degree_interp, sys)
    persistent u_control tu_s u_s counter;
    persistent xhat_1 phat_1 xhat_ phat_ t_0 t_curr;
    persistent xhat_traj_ xhat_trajs tail_traj head_traj;
    persistent u_parts source_states;
    
    rand_num = normrnd(pi/4, 0.1);
    
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
        xhat_trajs = [];
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
    
    if(isempty(xhat_traj_))
        xhat_traj_.t = [];
        xhat_traj_.x = [];
        
        time = 0:dt:T_traj;
        
        tail_traj = q_p(1:4);
        head_traj = [xhat; q_p(3) + rand_num; q_p(4)];
        
        wb = my_waitbar('Loading trajectory...');
        
        recalc_params = true;
        for j = 1:length(time)
            [xhat_traj, ~, ~, ~, ~] = ...
             generate_trajectory(time(j), dt, T_traj, ...
                                 tail_traj, head_traj,... 
                                 source_reference, ...
                                 degree_interp, sys, ...
                                 true);
                             
                             
            xhat_traj_.t = [xhat_traj_.t; time(j)];
            xhat_traj_.x = [xhat_traj_.x; xhat_traj'];            
            
            recalc_params = false;
            
            wb.update_waitbar(time(j), time(end));
        end
        
        wb.close_window();
        
        xhat_trajs = [xhat_trajs; xhat_traj_];
        assignin('base', 'xhat_trajs', xhat_trajs);
    end
    
    if(isempty(tail_traj))
        tail_traj = q_p(1:4);
    end
    
    if(isempty(head_traj))
        rand_num = normrnd(pi/2, 0.1);
        head_traj = [xhat; q_p(3) + rand_num; q_p(4)];
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
        u_control = control_calc(sys, P, W, eta, source_reference);
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
        if(t_curr >= t_0 + T_cur)
            t_0 = t;
            
            n = length(q);
            m = length(p);

            xhat_1 = xhat_;
            phat_1 = phat_;
            
            xhat_ = xhat;
            phat_ = phat;
            
            tail_traj = q_p(1:4);
            head_traj = [xhat_; q_p(3) + rand_num; q_p(4)];
            
            time = 0:dt:T_traj;
            
            xhat_traj_.t = [];
            xhat_traj_.x = [];
            
            wb = my_waitbar('Loading trajectory...');
            
            recalc_params = true;
            for j = 1:length(time)
                [xhat_traj, ~, ~, ~, ~] = ...
                 generate_trajectory(time(j), dt, T_traj, ...
                                     tail_traj, head_traj,... 
                                     source_reference, ...
                                     degree_interp, sys, ...
                                     true);
                
                xhat_traj_.t = [xhat_traj_.t; time(j)];
                xhat_traj_.x = [xhat_traj_.x; xhat_traj'];            
                
                recalc_params = false;
                wb.update_waitbar(time(j), time(end));
            end
            
            wb.close_window();
            
            xhat_trajs = [xhat_trajs; xhat_traj_];
            assignin('base', 'xhat_trajs', xhat_trajs);
        end
    end
    
    [xhat_traj, xphat_traj, xpphat_traj, ...
     phat_traj, pphat_traj] = ...
            generate_trajectory(t_curr, dt, ...
                                T_traj, tail_traj, head_traj,... 
                                source_reference, ...
                                degree_interp, sys, ...
                                false);
    
    syms_params = [q.', p.', xhat_s.', p_hat_s.', ...
                   xp_hat_s.', pp_hat_s.'];
               
    num_params = [q_p', xhat_traj', phat_traj', ...
                  xphat_traj', pphat_traj'];
    
              
              
    L_f_v = double(subs(u_control.L_f_v, syms_params, num_params));
    L_G_v = double(subs(u_control.L_G_v, syms_params, num_params));
    Vp = double(subs(u_control.Vp, syms_params, num_params));
    W = double(subs(u_control.W, syms_params, num_params));
    
    b = vpa(L_G_v*W);
    c = vpa(b.'/(b*b.'));
    
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