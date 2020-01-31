function u = lyap_based(t, q_p, xhat_traj, xphat_traj, xpphat_traj, ...
                        phat_traj, pphat_traj, sys, control_info)
    persistent u_control counter;
    
    P = control_info.P;
    W = control_info.W;
    eta = control_info.eta;
    
    if(isempty(u_control))
        u_control = control_calc(sys, control_info);
        assignin('base', 'u_control', u_control);
    end
    
    if(isempty(counter))
        counter = 0;
    end
    
    q = sys.kin.q;
    p = sys.kin.p{end};

    xhat_s = sym('qhat_', size(q));
    p_hat_s = sym('phat_', size(p));
    xp_hat_s = sym('qphat_', size(q));
    xpp_hat_s = sym('qpphat_', size(q));
    pp_hat_s = sym('pphat_', size(p));

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
    
    u = vpa((W*c)*(Vp - L_f_v));
end