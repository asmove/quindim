function u = run_control_law(t, q_p, xhat, ...
                             sestimation_info, ...
                             control_info, ...
                             trajectory_info, sys)
    persistent tu_s u_s t_0 t_curr source_states counter;
    persistent xhat_1 phat_1 xhat_ phat_ xhat_t phat_t pphat_t xphat_t;
    persistent xhat_traj_ xhat_trajs tail_traj head_traj;
    
    if(isempty(u_s))
        u_s = [];
    end
    
    if(isempty(tu_s))
        tu_s = [];
    end
    
    % Metadata unwrap
    xhat_0 = sestimation_info.xhat_0;
    zeta = sestimation_info.zeta;
    T_cur = sestimation_info.T_cur;
    source_reference = sestimation_info.source_reference;
    
    P = control_info.P;
    W = control_info.W;
    
    sigma_traj = trajectory_info.sigma_traj;
    T_traj = trajectory_info.T_traj;
    dt = trajectory_info.dt;
    degree_interp = trajectory_info.degree_interp;
    
    rand_num = normrnd(pi/4, 0.1);
    
    % States and velocity unwrap
    p = sys.kin.p{end};
    q = sys.kin.q;
    C = sys.kin.C;
    
    % Symbolic definitions
    xhat_s = sym('xhat_', size(source_reference));
    p_hat_s = sym('phat_', size(p));
    xp_hat_s = sym('xphat_', size(source_reference));
    xpp_hat_s = sym('xpphat_', size(source_reference));
    pp_hat_s = sym('pphat_', size(p));
    
    % Source states for signal estimation
    if(isempty(source_states))
        vars_reference = symvar(source_reference);
        is_state = ismember(vars_reference, q); 
        states_reference = vars_reference(is_state);

        is_reference_state = ismember(q, states_reference);
        remaining_source_states = q(~is_reference_state);

        source_states = states_reference.';
    end
    
    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(xhat_t))
        xhat_t = [];
        assignin('base', 'xhat_t', xhat_t);
    end
    
    if(isempty(phat_t))
        phat_t = [];
        assignin('base', 'phat_t', phat_t);
    end
    
    if(isempty(pphat_t))
        xhat_t = [];
        assignin('base', 'xhat_t', xhat_t);
    end
    
    if(isempty(xphat_t))
        phat_t = [];
        assignin('base', 'phat_t', phat_t);
    end
    
    if(isempty(xhat_trajs))
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
    
    time = 0:dt:T_traj;
    
    if(isempty(xhat_traj_))
        xhat_traj_.t = [];
        xhat_traj_.x = [];
        
        tail_traj = q_p(1:4);
        head_traj = [xhat; q_p(3); q_p(4)];
        
        wb = my_waitbar('Loading trajectory...');
        
        recalc_params = true;
        for j = 1:length(time)
            [xhat_traj, ~, ~, ~, ~] = ...
                trajectory_info.gentraj_fun(time(j), tail_traj, head_traj);
            
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
        head_traj = [xhat; q_p(3); q_p(4)];
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
    
    % Time for periodic variables
    t_curr = t;
    
    % Smoothed xhat
    n_xhat = length(xhat);
    
    counter = counter + 1;
    if(t_curr >= t_0 + T_cur)
        t_0 = t;

        n = length(q);
        m = length(p);

        xhat_1 = xhat_;
        phat_1 = phat_;

        xhat_ = xhat;
        phat_ = phat;

        tail_traj = q_p(1:4);
        head_traj = [xhat_; q_p(3); q_p(4)];

        time = 0:dt:T_traj;

        xhat_traj_.t = [];
        xhat_traj_.x = [];

        wb = my_waitbar('Loading trajectory...');

        recalc_params = true;
        for j = 1:length(time)
            [xhat_traj, ~, ~, ~, ~] = ...
                trajectory_info.gentraj_fun(time(j), tail_traj, ...
                                            head_traj);

            xhat_traj_.t = [xhat_traj_.t; time(j)];
            xhat_traj_.x = [xhat_traj_.x; xhat_traj'];            

            recalc_params = false;
            wb.update_waitbar(time(j), time(end));
        end

        wb.close_window();

        xhat_trajs = [xhat_trajs; xhat_traj_];
        assignin('base', 'xhat_trajs', xhat_trajs);
    end
    
    [xhat_traj, xphat_traj, xpphat_traj, ...
     phat_traj, pphat_traj] = trajectory_info.gentraj_fun(t - t_0, ...
                                                          tail_traj, ...
                                                          head_traj);
    
    u = control_info.control_fun(t, q_p, ...
                                 xhat_traj, xphat_traj, xpphat_traj, ...
                                 phat_traj, pphat_traj);
    
%     z_traj = normrnd(zeros(size(u)), sigma_traj);
%     u = u + z_traj;

    if(counter == 1)        
        phat_t = [phat_t; phat_traj'];
        xhat_t = [xhat_t; xhat_traj'];
        pphat_t = [pphat_t; pphat_traj'];
        xphat_t = [xphat_t; xphat_traj'];
        u_s = [u_s; u'];
        tu_s = [tu_s; t];
        
        assignin('base', 'u_s', u_s);
        assignin('base', 'tu_s', tu_s);
        assignin('base', 'xhat_t', xhat_t);
        assignin('base', 'phat_t', phat_t);
        assignin('base', 'xphat_t', xphat_t);
        assignin('base', 'pphat_t', pphat_t);
    end
    
    if(counter == 4)
        counter = 0;
    end
end