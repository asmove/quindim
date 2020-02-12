function u = lyap_based_2D(t, q_p, ref_func, control_info, sys)
    persistent u_control counter V_terms tV_s;
    persistent Lfv LGv V us;
    
    q = sys.kin.q;
    p = sys.kin.p{end};
    symbs = sys.descrip.syms;
    model_params = sys.descrip.model_params;
    
    qhat_s = sym('qhat_', size(q));
    qp_hat_s = sym('qphat_', size(q));
    qpp_hat_s = sym('qpphat_', size(q));
    
    syms_params = [q.', p.', qhat_s.', qp_hat_s.', qpp_hat_s.', symbs];    
    num_params = [q_p', ref_func(t)', model_params];
    
    size([qhat_s.', qp_hat_s.', qpp_hat_s.'])
    
    poles = control_info.poles;
    Lambda = ctrb_canon(poles);
    
    if(isempty(tV_s))
        tV_s = [];
    end
    
    if(isempty(V_terms))
        V_terms = [];
    end
    
    if(isempty(us))
        us = [];
    end
    
    if(isempty(u_control))
        u_control = control_calc(sys, control_info);
        assignin('base', 'u_control', u_control);
    end
    
    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(V))
        V = u_control.V_fun();
        Lfv = u_control.Lfv_fun(V);
        LGv = u_control.LGv_fun(V);
    end
    
    error = double(subs(u_control.error, syms_params, num_params));
    
    V_ = subs(V, syms_params, num_params);
    L_f_v = double(subs(Lfv, syms_params, num_params));
    L_G_v = double(subs(LGv, syms_params, num_params));
    Vp = u_control.Vp_fun(V_, error);
    W = double(subs(u_control.W, syms_params, num_params));
    
    b = vpa(L_G_v*W);
    c = vpa(b.'/(b*b.'));
    u = vpa((W*c)*(Vp - L_f_v));
    
    counter = counter + 1;
    if(counter == 1)
        tV_s = [tV_s; t];
        V_terms = [V_terms; subs(V, syms_params, num_params)];
        us = [us; u.'];
        
        assignin('base', 'tV_s', tV_s);
        assignin('base', 'V_terms', V_terms);
        assignin('base', 'us', us);
    end
    
    if(counter==4)
        counter = 0;
    end
end