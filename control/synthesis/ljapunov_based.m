function u = ljapunov_based(t, q_p, x_hat, Q, P, x, sys)
    persistent u_control

    is_positive(Q);
    is_positive(P);
    
    if(isempty(u_control))
        u_control = control_calc(sys, Q, P, x);
    end

    p = sys.kin.p{end};
    q = sys.kin.q;

    model_params = sys.descrip.model_params;
    syms_plant = sys.descrip.syms;
    
    u_control = subs(u_control, syms_plant, model_params);

    x = subs(x, [q; p], q_p);
    
    x_hat = x_hat';
    x_tilde = x - x_hat;
    
    x_hat_s = sym('xhat_', size(x));

    syms_params = [q.', p.', x_hat_s.'];
    num_params = [q_p', x_hat'];
    
    u = double(subs(u_control, syms_params, num_params));
end