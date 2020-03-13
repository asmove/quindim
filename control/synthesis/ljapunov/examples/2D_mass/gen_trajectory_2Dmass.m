function [xhat_vals, xphat_vals, xpphat_vals, ...
          p_vals, pp_vals] = gen_trajectory_2Dmass(t, dt, T, curr, next, ...
                                                   source_reference, ...
                                                   degree_interp, sys, ...
                                                   recalc_params, traj_type)
    persistent is_T params_syms params_sols traj_model;
    
    if(isempty(is_T) || t > T || recalc_params)
        is_T = true;
    end
        
    points_A.t = 0;
    points_A.coords = curr;
    
    points_B.t = T;
    points_B.coords = next;
    
    points = [points_A; points_B];
    
    symbs = sys.descrip.syms;
    model_params = sys.descrip.model_params;
    
    if(is_T)
        [params_syms, ...
         params_sols, ...
         traj_model] = gentrajmodel_2Dmass(sys, traj_type, T, points);
        
        is_T = false;
    end
    
    [q_vals, p_vals, ...
     qp_vals, pp_vals, ...
     qpp_vals] = traj_smooth(t, T, traj_model, params_syms, ...
                             params_sols, dt, points, sys);

%     [q_vals, p_vals, ...
%      qp_vals, pp_vals, ...
%      qpp_vals] = rolling_smoothstep(t - t0, T, dt, degree_interp, ...
%                                     symbs, model_params, points, sys);
    
    q = sys.kin.q;
    qp = sys.kin.qp;
    qpp = sys.kin.qpp;
    p = sys.kin.p{end};
    pp = sys.kin.pp{end};
    C = sys.kin.C;
    Cp = sys.kin.Cp;
    
    xphat = dvecdt(source_reference, q, qp);
    xpphat = dvecdt(xphat, [q; qp], [C*p; Cp*p + Cp*pp]);
    xphat = subs(xphat, ...
                 [qp; symbs.'], ...
                 [C*p; model_params']);
    xpphat = subs(xpphat, ...
                  [qp; qpp; symbs.'], ...
                  [C*p; Cp*p + Cp*pp; model_params']);
    
    xhat_vals = double(subs(source_reference, q, q_vals));
    
    xphat_vals = double(subs(xphat, [q; p; symbs.'], ...
                             [q_vals; p_vals; model_params']));
    xpphat_vals = double(subs(xpphat, [q; p; pp], ...
                               [q_vals; p_vals; pp_vals]));
end