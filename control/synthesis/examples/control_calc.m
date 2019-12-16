function u = control_calc(sys, Q, P, x)
    p = sys.kin.p{end};
    q = sys.kin.q;
    H = sys.dyn.H;
    C = sys.kin.C;
    x = sys.kin.q(1:2);
    h = sys.dyn.h;
    u = sys.dyn.u;
    Z = sys.dyn.Z;
    
    x_hat = sym('xhat_', size(x));
    pp = inv(H)*(Z*u - h);

    P = eye(length(x));

    e_x = x - x_hat;

    V = 0.5*p.'*H*p + 0.5*e_x.'*P*e_x;
    Vp = -p.'*H*p - e_x.'*Q*e_x;

    var = [q; p; x_hat];
    dvar = [C*p; pp; zeros(size(x_hat))];

    Vp_ = dvecdt(V, var, dvar);

    omega_T = equationsToMatrix(Vp_, u);

    omega = omega_T.';
    omega_ww = omega/(omega_T*omega);
    
    Vp_u = Vp_ - omega_T*u;

    u = simplify_(omega_ww*(Vp - Vp_u));
end