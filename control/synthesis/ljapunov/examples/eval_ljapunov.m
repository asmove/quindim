function Vs = eval_ljapunov(t_s, sys, sol, ref_func, control_info)
    q = sys.kin.q;
    p = sys.kin.p{end};

    H = sys.dyn.H;
    C = sys.kin.C;
    x = source_reference;
    h = sys.dyn.h;
    u = sys.descrip.u;
    Z = sys.dyn.Z;
    
    syms_plant = sys.descrip.syms;
    model_params = sys.descrip.model_params;
    
    qhat_s = sym('qhat_', size(q));
    qp_hat_s = sym('qphat_', size(q));
    qpp_hat_s = sym('qpphat_', size(q));
    pp = inv(H)*(Z*u - h);
    
    u_struct = control_calc(sys, control_info);
    
    poles_ = control_info.poles;
    Lambda = ctrb_canon(poles_);
    
    e_q = q - q_hat;
    e_qp = qp - qp_hat;
    e = e_qp - Lambda*e_q;
    V = e.'*H*e;

    qp_s = [q; p];

    n_t = length(t_s);

    wb = my_waitbar('Calculating Ljapunov');
    
    Vs = zeros(n_t, 1);
    for i = 1:n_t
        t_i = t_s(i);

        xhat_i = xhat_t(i, :);
        phat_i = phat_t(i, :);

        symbs = [qp_s; syms_plant.'; qhat_s; qp_hat_s; qpp_hat_s];
        vals = [sol(i, :)'; model_params'; ref_func(t_i)];

        Vs(i) = subs(V, symbs, vals);
    
        wb.update_waitbar(i, n_t);
    end
    
    wb.close_window();
end