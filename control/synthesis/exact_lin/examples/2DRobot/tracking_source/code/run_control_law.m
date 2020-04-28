function [u, dz] = run_control_law(t, q_p, xhat, sestimation_info, ...
                                   trajectory_info, control_info, sys)
    persistent tu_s u_s t_0 source_states counter;
    persistent tail_traj head_traj is_T;
    persistent t_trajs trajs t_trajs_curr trajs_curr;
    
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
    
    if(isempty(t_trajs))
        t_trajs = {};
    end
    
    if(isempty(trajs))
        trajs = {};
    end
    
    if(isempty(t_trajs_curr))
        t_trajs_curr = [];
    end
    
    if(isempty(trajs_curr))
        trajs_curr = [];
    end
    
    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(t_0))
        t_0 = 0;
    end
    
    if(isempty(tail_traj))
        tail_traj = q_p(1:2);
    end
    
    if(isempty(head_traj))
        head_traj = xhat;
    end
    
    if(isempty(head_traj))
        xhat_trajs = [];
    end
    
    if(isempty(is_T))
        is_T = false;
    end
    
    % Time for periodic variables
    t_curr = t;
    
    % Smoothed xhat
    n_xhat = length(xhat);
    
    if(T_traj < T_cur)
        error('Trajectory plan time span must be greater than curiosity time');
    end
    
    if(xhat ~= head_traj)
        t_0 = t;

        n = length(q);
        m = length(p);

        xhat_traj_.t = [];
        xhat_traj_.x = [];

        tail_traj = q_p(1:2);
        head_traj = xhat;

        P0 = tail_traj;
        P1 = head_traj;
        thetaA = q_p(3);

        t_i = t_curr - t_0;

        traj = trajectory_info.gentraj_fun(t_i, P0, P1, thetaA);

        xhat_traj = traj(1:2);
        xphat_traj = traj(2:3);
        xpphat_traj = traj(4:5);
        xppphat_traj = traj(6:7);

        t_trajs{end+1} = t_trajs_curr;
        trajs{end+1} = trajs_curr;

        t_trajs_curr = [];
        trajs_curr = [];

        assignin('base', 't_trajs', t_trajs);
        assignin('base', 'trajs', trajs);

        is_T = false;
    end
    
    P0 = tail_traj;
    P1 = head_traj;
    thetaA = q_p(3);
    
    t_i = t - t_0;
    traj = trajectory_info.gentraj_fun(t_i, P0, P1, thetaA);
    
    xhat_traj = traj(1:2);
    xphat_traj = traj(3:4);
    xpphat_traj = traj(5:6);
    xppphat_traj = traj(7:8);
    
    xppp = sym('xppp');
    yppp = sym('yppp');
    y_ref = add_symsuffix(sys.kin.q(1:2), '_ref');
    yp_ref = add_symsuffix(sys.kin.qp(1:2), '_ref');
    ypp_ref = add_symsuffix(sys.kin.qpp(1:2), '_ref');
    yppp_ref = add_symsuffix([xppp; yppp], '_ref');
    
    qp_symbs = sym('x_', [6, 1]);
    refs_symbs = [y_ref; yp_ref; ypp_ref; yppp_ref];
    refs = [xhat_traj; xphat_traj; xpphat_traj; xppphat_traj];
    
    t0 = tic();
    [dz, u] = control_info.control_fun(t, q_p, refs, ...
                                       qp_symbs, refs_symbs);
    toc(t0)
                                   
    counter = counter + 1;
    if(counter == 1)
        u_s = [u_s; u'];
        tu_s = [tu_s; t];
        t_trajs_curr = [t_trajs_curr; t];
        trajs_curr = [trajs_curr; xhat_traj'];
        
        assignin('base', 'u_s', u_s);
        assignin('base', 'tu_s', tu_s);
    end
    
    if(counter == 4)
        counter = 0;
    end
    
    disp('-----');
    disp(sprintf('Position   : [%.3f, %.3f]', q_p(1), q_p(2)));
    disp(sprintf('Reference  : [%.3f, %.3f]', refs(1), refs(2)));
    disp(sprintf('Errors     : [%.3f, %.3f]', q_p(1) - refs(1), ...
                                              q_p(2) - refs(2)));
    disp(sprintf('Estimation : [%.3f, %.3f]', xhat(1), xhat(2)));
    disp('-----');
end