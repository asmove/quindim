function u = lyap_based(t, q_p, xhat_traj, xphat_traj, xpphat_traj, ...
                        phat_traj, pphat_traj, sys, control_info)
    persistent u_control counter V_pterms V_qterms tV_s;
    persistent Lfv LGv V;
    
    q = sys.kin.q;
    p = sys.kin.p{end};
    symbs = sys.descrip.syms;
    model_params = sys.descrip.model_params;
    
    xhat_s = sym('qhat_', size(q));
    p_hat_s = sym('phat_', size(p));
    xp_hat_s = sym('qphat_', size(q));
    xpp_hat_s = sym('qpphat_', size(q));
    pp_hat_s = sym('pphat_', size(p));

    syms_params = [q.', p.', xhat_s.', p_hat_s.', ...
                   xp_hat_s.', pp_hat_s.', symbs];
    
    num_params = [q_p', xhat_traj', phat_traj', ...
                  xphat_traj', pphat_traj', model_params];
    
    poles = control_info.poles;
    Lambda = ctrb_canon(poles);
    
    if(isempty(tV_s))
        tV_s = [];
    end
    
    if(isempty(u_control))
        u_control = control_calc(sys, control_info);
        assignin('base', 'u_control', u_control);
    end
    
    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(V))
        V = u_control.V_fun(alpha_q, alpha_p);
        Lfv = u_control.Lfv_fun(V);
        LGv = u_control.LGv_fun(V);
    end
    
    L_f_v = double(subs(Lfv, syms_params, num_params));
    L_G_v = double(subs(LGv, syms_params, num_params));
    Vp = u_control.Vp_fun(V, syms_params, num_params);
    W = double(subs(u_control.W, syms_params, num_params));
    
    b = vpa(L_G_v*W);
    c = vpa(b.'/(b*b.'));
    u = vpa((W*c)*(Vp - L_f_v));
    
    counter = counter + 1;
    if(counter == 1)
        V_pterms = [V_pterms; V_pterm];
        V_qterms = [V_qterms; V_qterm];
        tV_s = [tV_s; t];

        assignin('base', 'V_pterms', V_pterms);
        assignin('base', 'V_qterms', V_qterms);
        assignin('base', 'tV_s', tV_s);
    end
    
    if(counter==4)
        counter = 0;
    end
end