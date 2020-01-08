function [xhat_vals, xphat_vals, xpphat_vals, ...
          p_vals, pp_vals] = generate_trajectory(t, t0, dt, T, ...
                                                 prev, curr, ...
                                                 source_reference, ...
                                                 degree_interp, sys)
                                             
    points_A.coords = prev;
    points_B.coords = curr;
    
    points = [points_A; points_B];
    
    symbs = sys.descrip.syms;
    model_params = sys.descrip.model_params;
    
    [q_vals, p_vals, ...
     qp_vals, pp_vals, qpp_vals] = ...
            rolling_smoothstep(t - t0, T, dt, degree_interp, ...
                               symbs, model_params, points, sys);
    
    q = sys.kin.q;
    qp = sys.kin.qp;
    qpp = sys.kin.qpp;
    p = sys.kin.p{end};
    pp = sys.kin.pp{end};
    C = sys.kin.C;
    Cp = sys.kin.Cp;
    
    xphat = dvecdt(source_reference, q, qp);
    xpphat = dvecdt(xphat, [q; qp], [C*p; Cp*p + Cp*pp]);
    
    xphat = subs(xphat, qp, C*p);
    xpphat = subs(xpphat, [qp; qpp], [C*p; Cp*p + Cp*pp]);
    
    xhat_vals = subs(source_reference, q, q_vals);
    xphat_vals = subs(xphat, [q; p], [q_vals; p_vals]);
    xpphat_vals = subs(xpphat, [q; p; pp], [q_vals; p_vals; pp_vals]);
                                        
%     n_xhat = length(xhat_);
%     
%     xhat_traj = zeros(size(xhat_));
%     for i = 1:n_xhat
%         t_local = t - t0;
%         perc_T = perc_interp*T;
%                 
%         xhat_traj(i) = smoothstep(t_local, perc_T, xhat_1(i), ...
%                                   xhat_(i), degree_interp);
%     end
%     
%     % Smoothed xphat
%     xphat_traj= zeros(size(xhat_));
%     for i = 1:n_xhat
%         t_local = t - t0;
%         perc_T = perc_interp*T;
%         
%         xphat_traj(i) = ndsmoothstep(t_local, perc_T, xhat_1(i), ...
%                                      xhat_(i), degree_interp, 1);
%     end
%     
%     % Smoothed xphat
%     xpphat_traj = zeros(size(xhat_));
%     for i = 1:n_xhat
%         t_local = t - t0;
%         perc_T = perc_interp*T;
%         
%         xpphat_traj(i) = ndsmoothstep(t_local, perc_T, xhat_1(i), ...
%                                       xhat_(i), degree_interp, 2);
%     end
%     
%     % Smoothed phat
%     phat_traj = zeros(size(phat_));
%     for i = 1:n_xhat
%         t_local = t - t0;
%         perc_T = perc_interp*T;
%         
%         phat_traj(i) = smoothstep(t_local, perc_T, phat_1(i), ...
%                                   phat_(i), degree_interp);
%     end
%     
%     % Smoothed pphat
%     pphat_traj = zeros(size(phat_));
%     for i = 1:n_xhat
%         t_local = t - t0;
%         perc_T = perc_interp*T;
%         
%         pphat_traj(i) = ndsmoothstep(t_local, perc_T, phat_1(i), ...
%                                      phat_(i), degree_interp, 1);
%     end
end