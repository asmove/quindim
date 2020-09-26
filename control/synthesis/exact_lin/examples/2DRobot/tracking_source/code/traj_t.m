function traj = traj_t(t, T, P0, P1, theta0, traj_type, sys)
    persistent traj_params P0_prev;
    
    P0 = double(P0);
    P1 = double(P1);
    
    syms t_;
    
    EPS_ = 1e-5;
    if(isempty(traj_params)||(norm(P0_prev - P0) > EPS_))
        traj_params = get_trajparams(t, T, P0, P1, theta0, traj_type, sys);
    end
    
    traj = subs([traj_params.xy_t; 
                 traj_params.dxy_t; 
                 traj_params.d2xy_t; 
                 traj_params.d3xy_t], t_, t);
end

