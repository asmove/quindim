function u = ljapunov_based(sys, Q, P, x)
    is_positive(Q);
    is_positive(P);

    H = sys.dyn.H;
    h = sys.dyn.h;
    C = sys.kin.C;
    p = sys.kin.p;
    q = sys.kin.q;
    
    Hp = dmatdt(H, q, C*p);

    omega_T = sys.kin.p.'*sys.dyn.Z;
    
    x_hat = sym('xhat_', size(x));
    
    x_tilde = x - x_hat;
    x_q = jacobian(x, q);
    
    alpha = simplify_((1/2*norm(omega_T)^2)*(p.'*(H + 2*Hp)*p + ...
            x_tilde.'*(Q*x_tilde - 2*P*x_q*C*p) ...
            - 2*p.'*h));
    
    u = -alpha*omega_T.';
end