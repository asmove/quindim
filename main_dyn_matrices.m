function [M, g, f, nu, U] = main_dyn_matrices(sys)
    qpp = sys.qpp;
    u = sys.u;
    M = mass_matrix(sys);
    g = gravitational(sys);
    f = friction(sys);
    U = -jacobian(sys.l_r, u);
    nu = sys.l_r - M*qpp - g - f + U*u;
end