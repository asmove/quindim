function [dz, u] = run_control_law(t, q_p, xhat, sestimation_info, ...
                                   control_info, trajectory_info, sys)
    persistent tu_s u_s t_0 t_curr source_states counter;
    persistent tail_traj head_traj;
    
    % Metadata unwrap
    xhat_0 = sestimation_info.xhat_0;
    zeta = sestimation_info.zeta;
    T_cur = sestimation_info.T_cur;
    source_reference = sestimation_info.source_reference;
    
    T_traj = trajectory_info.T_traj;
    dt = trajectory_info.dt;
    
    % States and velocity unwrap
    p = sys.kin.p{end};
    q = sys.kin.q;
    C = sys.kin.C;
    
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
    
    % Time for periodic variables
    t_curr = t;
    
    % Smoothed xhat
    n_xhat = length(xhat);
    
    if(T_traj < T_cur)
        error('Trajectory plan time span must be greater than curiosity time');
    end
    
    counter = counter + 1;
    if(t_curr >= t_0 + T_cur)
        t_0 = t;

        n = length(q);
        m = length(p);

        xhat_traj_.t = [];
        xhat_traj_.x = [];
        
        tail_traj = q_p(1:2);
        head_traj = xhat;
        
        P0 = tail_traj;
        P1 = head_traj; 
        
        t_i = t_curr - t_0;
        
        xhat_traj = P0 + (t_i/T_traj)*(P1 - P0);
        xphat_traj = (P1 - P0)/T_traj;
        xpphat_traj = zeros(size(P1));
        xppphat_traj = zeros(size(P1));

        xhat_traj_.t = [xhat_traj_.t; time(j)];
        xhat_traj_.x = [xhat_traj_.x; xhat_traj'];            

        xhat_trajs = [xhat_trajs; xhat_traj_];
        assignin('base', 'xhat_trajs', xhat_trajs);
    end
    
    P0 = tail_traj;
    P1 = head_traj;
    t_i = t_curr - t_0;

    xhat_traj = P0 + (t_i/T_traj)*(P1 - P0);
    xphat_traj = (P1 - P0)/T_traj;
    xpphat_traj = zeros(size(P1));
    xppphat_traj = zeros(size(P1));
    
    xppp = sym('xppp');
    yppp = sym('yppp');
    y_ref = add_symsuffix(sys.kin.q(1:2), '_ref');
    yp_ref = add_symsuffix(sys.kin.qp(1:2), '_ref');
    ypp_ref = add_symsuffix(sys.kin.qpp(1:2), '_ref');
    yppp_ref = add_symsuffix([xppp; yppp], '_ref');
    
    qp_symbs = [q; p];
    refs_symbs = [y_ref; yp_ref; ypp_ref; ypp_ref];
    refs = [xhat_traj; xphat_traj; xpphat_traj; xppphat_traj];
    
    [dz, u] = control_info.control_fun(t, q_p, ...
                                       refs, qp_symbs, refs_symbs);
    
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