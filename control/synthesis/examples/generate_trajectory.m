function [xhat_traj, xphat_traj, xpphat_traj, ...
          phat_traj, pphat_traj] = generate_trajectory(t, t0, T, ...
            xhat_1, xhat_, phat_1, phat_, sys)
    
    % Interpolation properties
    perc_interp = 0.3;
    degree_interp = 1;
    
    n_xhat = length(xhat_);
    
    xhat_traj = zeros(size(xhat_));
    for i = 1:n_xhat
        t_local = t - t0;
        perc_T = perc_interp*T;
                
        xhat_traj(i) = smoothstep(t_local, perc_T, xhat_1(i), ...
                                  xhat_(i), degree_interp);
    end
    
    % Smoothed xphat
    xphat_traj= zeros(size(xhat_));
    for i = 1:n_xhat
        t_local = t - t0;
        perc_T = perc_interp*T;
        
        xphat_traj(i) = ndsmoothstep(t_local, perc_T, xhat_1(i), ...
                                     xhat_(i), degree_interp, 1);
    end
    
    % Smoothed xphat
    xpphat_traj = zeros(size(xhat_));
    for i = 1:n_xhat
        t_local = t - t0;
        perc_T = perc_interp*T;
        
        xpphat_traj(i) = ndsmoothstep(t_local, perc_T, xhat_1(i), ...
                                      xhat_(i), degree_interp, 2);
    end
    
    % Smoothed phat
    phat_traj = zeros(size(phat_));
    for i = 1:n_xhat
        t_local = t - t0;
        perc_T = perc_interp*T;
        
        phat_traj(i) = smoothstep(t_local, perc_T, phat_1(i), ...
                                  phat_(i), degree_interp);
    end
    
    % Smoothed pphat
    pphat_traj = zeros(size(phat_));
    for i = 1:n_xhat
        t_local = t - t0;
        perc_T = perc_interp*T;
        
        pphat_traj(i) = ndsmoothstep(t_local, perc_T, phat_1(i), ...
                                     phat_(i), degree_interp, 1);
    end
end