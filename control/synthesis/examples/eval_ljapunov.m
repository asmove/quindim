function Vs = eval_ljapunov(t_s, sys, sol, xhat_t, phat_t, source_reference, P)
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
    
    x_hat = sym('xhat_', size(x));
    p_hat = sym('phat_', size(x));
    pp = inv(H)*(Z*u - h);

    e_x = x - x_hat;
    e_p = p - p_hat;
    V = e_p.'*H*e_p + e_x.'*P*e_x;

    qp_s = [q; p];

    n_t = length(t_s);

    wb = my_waitbar('Calculating Ljapunov');
    
    Vs = zeros(n_t, 1);
    for i = 1:n_t
        t_i = t_s(i);

        xhat_i = xhat_t(i, :);
        phat_i = phat_t(i, :);

        symbs = [qp_s; syms_plant.'; x_hat; p_hat];
        vals = [sol(i, :)'; model_params'; xhat_i'; phat_i'];

        Vs(i) = subs(V, symbs, vals);
    
        wb.update_waitbar(i, n_t);
    end
    
    wb.close_window();
end