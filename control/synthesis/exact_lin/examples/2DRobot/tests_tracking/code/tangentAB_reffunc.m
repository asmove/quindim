function ref_ = tangentAB_reffunc(t, traj_params)
    syms t_;

    % Time and trajectory vector 
    t_traj1 = traj_params.t_traj{1};
    t_traj2 = traj_params.t_traj{2};
    t_traj3 = traj_params.t_traj{3};

    t_traj = double([t_traj1; t_traj2; t_traj3]);

    traj1 = traj_params.trajectory{1};
    traj2 = traj_params.trajectory{2};
    traj3 = traj_params.trajectory{3};
    traj = double([traj1; traj2; traj3]);
    t = double(t);

    xy_t = interp1(t_traj, traj, t)';
    dxy_t = traj_params.traj_diff(t, 1);
    d2xy_t = traj_params.traj_diff(t, 2);
    d3xy_t = traj_params.traj_diff(t, 3);

    traj = [xy_t; dxy_t; d2xy_t; d3xy_t];

    ref_ = subs(traj, t_, t);
end