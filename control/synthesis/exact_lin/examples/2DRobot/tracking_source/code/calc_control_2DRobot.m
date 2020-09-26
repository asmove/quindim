function [dz, u, misc] = calc_control_2DRobot(sys, poles_)
    % Output and reference
    y = sys.kin.q(1:2);
    
    % States of the system
    states = sys.dyn.states;

    % States and velocities od the system
    q = sys.kin.q;
    qp = sys.kin.qp;
    p = sys.kin.p{end};

    % Coupling matrix
    C = sys.kin.C;
    Cp = sys.kin.Cp;

    % Dynamic matrices
    H = sys.dyn.H;
    h = sys.dyn.h;
    Z = sys.dyn.Z;
    
    % Input
    u = sys.descrip.u;
    
    [n_q, n_p] = size(C);
    [n_p, n_u] = size(Z);
    
    % Plant
    f = [C*p; -inv(H)*h];
    G = [zeros([n_q, n_p]); -inv(H)*Z];
    
    v = sym('v', size(u));
    
    % New input
    w_1 = sym('w_1');
    w_2 = sym('w_2');
    w = sym('w', [2, 1]);
    
    syms xppp yppp;
    
    y_ref = add_symsuffix(sys.kin.q(1:2), '_ref');
    yp_ref = add_symsuffix(sys.kin.qp(1:2), '_ref');
    ypp_ref = add_symsuffix(sys.kin.qpp(1:2), '_ref');
    yppp_ref = add_symsuffix([xppp; yppp], '_ref');
    
    z_1 = sym('z_1');
    x_orig = [q; p; v(2)];
    x_sym = sym('x_', [n_q + n_p + 1, 1]);

    v = sym('v', [2, 1]);

    ref_syms = [y_ref; yp_ref; ypp_ref; yppp_ref];

    % Output equations
    y1 = y(1);
    y2 = y(2);

    % First derivative for outputs
    dy1dt = dvecdt(y1, [q; p], [C*p; v]);
    dy2dt = dvecdt(y2, [q; p], [C*p; v]);
    
    L_G_L_f_h1 = equationsToMatrix(dy1dt, v);
    L_G_L_f_h2 = equationsToMatrix(dy2dt, v);

    L_f_h1 = simplify_(dy1dt - L_G_L_f_h1*v);
    L_f_h2 = simplify_(dy2dt - L_G_L_f_h2*v);

    % Second derivative for outputs
    d2y1dt2 = dvecdt(dy1dt, [q; p], [C*p; v]);
    d2y2dt2 = dvecdt(dy2dt, [q; p], [C*p; v]);
    
    L_G_L_f_2_h1 = equationsToMatrix(d2y1dt2, v);
    L_G_L_f_2_h2 = equationsToMatrix(d2y2dt2, v);
    
    A1 = [L_G_L_f_2_h1; L_G_L_f_2_h2];
    
    L_2_f_h1 = simplify_(d2y1dt2 - L_G_L_f_h1*v);
    L_2_f_h2 = simplify_(d2y2dt2 - L_G_L_f_h2*v);
    
    % System analysis
    x_params = ones(length(x_sym), 1);

    w_syms = [w_1; w_2];

    u_new = [z_1; w_2];
    V = eye([2, 2]);
    qpz = [q; p; z_1];
    
    % Plant
    plant = subs([C*p; V*u_new; w_1], qpz, x_sym);
    zp = w_1;

    G_x = equationsToMatrix(plant, [w_1; w_2]);
    f_x = simplify_(plant - G_x*[w_1; w_2]);
    
    % Old input
    w_s = [z_1; w_2];
    
    % y1
    y1 = subs(y1, x_orig, x_sym);
    dy1dt = subs(dy1dt, x_orig, x_sym);
    d2y1dt2 = subs(d2y1dt2, x_orig, x_sym);
    d2y1dt2 = subs(d2y1dt2, v(1), x_sym(n_q + n_p + 1));
    d3y1dt3 = simplify_(dvecdt(d2y1dt2, x_sym, plant));
    
    % y2
    y2 = subs(y2, x_orig, x_sym);
    dy2dt = subs(dy2dt, x_orig, x_sym);
    d2y2dt2 = subs(d2y2dt2, x_orig, x_sym);
    d2y2dt2 = subs(d2y2dt2, v(1), x_sym(n_q + n_p + 1));
    d3y2dt3 = simplify_(dvecdt(d2y2dt2, x_sym, plant));
    
    dydt = [dy1dt; dy2dt];
    d2ydt2 = [d2y1dt2; d2y2dt2];
    
    % Lie derivative terms
    % ---------------------------------------------------------
    % First derivative
    L_G_h1 = equationsToMatrix(dy1dt, w_syms);
    L_G_h2 = equationsToMatrix(dy2dt, w_syms);

    L_f_h1 = simplify_(dy1dt - L_G_h1*w_syms);
    L_f_h2 = simplify_(dy2dt - L_G_h2*w_syms);

    % ---------------------------------------------------------
    % Second derivative
    L_G_L_f_h1 = equationsToMatrix(d2y1dt2, w_syms);
    L_G_L_f_h2 = equationsToMatrix(d2y2dt2, w_syms);
    
    L_2_f_h1 = simplify_(d2y1dt2 - L_G_L_f_h1*w_syms);
    L_2_f_h2 = simplify_(d2y2dt2 - L_G_L_f_h2*w_syms);
    
    % ---------------------------------------------------------
    % Third derivative
    
    L_G_L_2_f_h1 = equationsToMatrix(d3y1dt3, w_syms);
    L_G_L_2_f_h2 = equationsToMatrix(d3y2dt3, w_syms);
    
    L_3_f_h1 = simplify_(d3y1dt3 - L_G_L_2_f_h1*w_syms);
    L_3_f_h2 = simplify_(d3y2dt3 - L_G_L_2_f_h2*w_syms);
    
    A2 = [L_G_L_2_f_h1; L_G_L_2_f_h2];
    
    y = sys.kin.q(1:2);
    yp = sys.kin.qp(1:2);
    ypp = sys.kin.qpp(1:2);
    yppp = [xppp; yppp];

    % Error and its derivatives
    e = x_sym(1:2) - y_ref;
    ep = dydt - yp_ref;
    epp = d2ydt2 - ypp_ref;

    coeffs_1 = poly(poles_{1});
    coeffs_1 = coeffs_1(2:end);
    coeffs_2 = poly(poles_{2});
    coeffs_2 = coeffs_2(2:end);
    
    coeffs_1
    coeffs_2
    
    coeffs_sym1 = sym('a_1', [3, 1]);
    coeffs_sym2 = sym('a_2', [3, 1]);
    
    coeffs_K0_sym = [coeffs_sym1(3); coeffs_sym2(3)];
    coeffs_K1_sym = [coeffs_sym1(2); coeffs_sym2(2)];
    coeffs_K2_sym = [coeffs_sym1(1); coeffs_sym2(1)];
    
    coeffs_sym = [coeffs_K0_sym; coeffs_K1_sym; coeffs_K2_sym];
    
    coeffs_K0 = [coeffs_1(3); coeffs_2(3)];
    coeffs_K1 = [coeffs_1(2); coeffs_2(2)];
    coeffs_K2 = [coeffs_1(1); coeffs_2(1)];
    
    coeffs_ = [coeffs_K0; coeffs_K1; coeffs_K2];
    
    K0 = diag(coeffs_K0_sym);
    K1 = diag(coeffs_K1_sym);
    K2 = diag(coeffs_K2_sym);
    
    L_3_f_h = simplify_([L_3_f_h1; L_3_f_h2]);
    
    m = length(A2);
    
    symbs = sys.descrip.syms.';
    model_params = sys.descrip.model_params.';
    
    symbs = [symbs; coeffs_sym];
    model_params = double([model_params; coeffs_]);
    
    symbs
    model_params
    
    invA2 = simplify_(inv(A2));
    
    w = simplify_(vpa(invA2*(-L_3_f_h-K2*epp-K1*ep-K0*e+yppp_ref)));    
    v_ = V*[x_sym(n_q + n_p + 1); w(2)];
    
    x_sym = sym('x_', [n_q + n_p + 1, 1]);
    x_orig = [q; p; x_sym(n_q + n_p + 1)];
    
    u = subs(inv(Z)*(H*v_ + h), x_orig, x_sym);
    misc.u_sym = expand(u);
    u = vpa(expand(subs(u, symbs, model_params)));
    
    dz = w(1);
    
    dz = subs(dz, symbs, model_params);
    
    misc.e = e;
    misc.ep = ep;
    misc.epp = epp;
    misc.xy = [y1; y2];
    misc.dxy = [dy1dt; dy2dt];
    misc.d2xy = [d2y1dt2; d2y2dt2];
    misc.symvars = [x_sym; ref_syms];
    misc.childrens = children(u);
end
