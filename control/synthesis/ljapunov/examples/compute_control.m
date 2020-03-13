function u = compute_control(t, states, referece, ...
                             reference_syms, control_law, qp_syms)
    q = sys.kin.q;
    p = sys.kin.p;
    
    syms_params = [qp_sys, reference];               
    num_params = [states, reference_syms];
    
    L_f_v = double(subs(u_control.L_f_v, syms_params, num_params));
    L_G_v = double(subs(u_control.L_G_v, syms_params, num_params));
    Vp = double(subs(u_control.Vp, syms_params, num_params));
    W = double(subs(u_control.W, syms_params, num_params));
    
    b = vpa(L_G_v*W);
    c = vpa(b.'/(b*b.'));
    
    u = double((W*c)*(Vp - L_f_v));

    if(counter == 1)
        aux.L_f_v = L_f_v;
        aux.L_G_v = L_G_v;
        aux.Vp = Vp;
        
        u_parts = [u_parts; aux];
        u_s = [u_s; u'];
        tu_s = [tu_s; t];
        
        assignin('base', 'u_parts', u_parts);
        assignin('base', 'u_s', u_s);
        assignin('base', 'tu_s', tu_s);
    end
end