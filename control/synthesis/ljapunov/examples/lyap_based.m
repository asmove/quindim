function u = lyap_based(t, q_p, q_ref, sys)
    persistent u_control u_parts u_s tu_s counter;
    
    if(isempty(u_control))
        u_control = control_calc(sys, P, W, eta, source_reference);
        assignin('base', 'u_control', u_control);
    end
    
    if(isempty(counter))
        counter = 0;
    end
    
    q = sys.kin.q;
    p = sys.kin.p{end};

    xhat_s = sym('xhat_', size(source_reference));
    p_hat_s = sym('phat_', size(p));
    xp_hat_s = sym('xphat_', size(source_reference));
    xpp_hat_s = sym('xpphat_', size(source_reference));
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
    
    u = double((W*c)*(Vp - L_f_v));

    if(counter == 1)
        u_parts = [u_parts; aux];
        u_s = [u_s; u'];
        tu_s = [tu_s; t];
        assignin('base', 'u_parts', u_parts);
        assignin('base', 'u_s', u_s);
        assignin('base', 'tu_s', tu_s);
    end
    
    if(counter == 4)
        counter = 0;
    end
end