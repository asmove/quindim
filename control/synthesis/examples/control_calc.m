function u_struct = control_calc(sys, P, n_G, W, eta, x)
    if(n_G < 0)
        error('Control action degree MUST be greater than 1!');
    end
    
    is_positive(W);
    is_diagonal(W);
    
    % Main dynamic matrices
    p = sys.kin.p{end};
    q = sys.kin.q;
    H = sys.dyn.H;
    C = sys.kin.C;
    x = sys.kin.q(1:2);
    h = sys.dyn.h;
    u = sys.descrip.u;
    Z = sys.dyn.Z;
    
    % Control utils
    x_hat = sym('xhat_', size(x));
    p_hat = sym('phat_', size(p));
    xp_hat = sym('xphat_', size(x));
    pp_hat = sym('pphat_', size(p));
    
    f = [C*p; -inv(H)*h];
    G = [zeros(length(q), length(u)); inv(H)*Z];
    
    % Ljapunov positive function
    P = eye(length(x));
    
    % x and p errors
    e_x = x - x_hat;
    e_p = p - p_hat;

    % Ljapunov function and its derivative
    V = e_p.'*H*e_p + e_x.'*P*e_x;
    Vp = -eta*V;
    
    L_f_v = lie_diff(f, V, [q; p]);
    L_G_v = lie_diff(G, V, [q; p]);

    model_params = sys.descrip.model_params;
    syms_plant = sys.descrip.syms;

    u_struct.L_f_v = simplify_(vpa(subs(L_f_v, syms_plant, model_params)));
    u_struct.L_G_v = simplify_(vpa(subs(L_G_v, syms_plant, model_params)));
    u_struct.Vp = simplify_(vpa(subs(Vp, syms_plant, model_params)));
    u_struct.W = W;
    u_struct.n_G = n_G;
end