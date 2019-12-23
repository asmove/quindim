function u = control_calc(sys, P, eta, x)
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
    p_hat = sym('phat_', size(x));
    xp_hat = sym('xphat_', size(x));
    pp_hat = sym('pphat_', size(x));
    
    pp = inv(H)*(Z*u - h);

    % Ljapunov positive function
    P = eye(length(x));
    
    % x and p errors
    e_x = x - x_hat;
    e_p = p - p_hat;

    % Ljapunov function and its derivative
    V = e_p.'*H*e_p + e_x.'*P*e_x;
    Vp = -eta*V;
    
    % Control utils
    var = [q; p; x_hat; p_hat];
    dvar = [C*p; pp; xp_hat; pp_hat];

    Vp_ = dvecdt(V, var, dvar);
    
    omega_T = equationsToMatrix(Vp_, u);
    
    omega = omega_T.';
    omega_ww = omega/(omega_T*omega);
    
    Vp_u = Vp_ - omega_T*u;
    
    % Control law
    u = simplify_(omega_ww*(Vp - Vp_u));
end