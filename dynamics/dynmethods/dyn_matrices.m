function sys = dyn_matrices(sys)
    u = sys.u;
    
    % Dynamic matrices of a mechanical system
    sys.dyn.M = simplify_(mass_matrix(sys), 10);
    sys.dyn.g = simplify_(gravitational(sys), 10);
    sys.dyn.f = simplify_(friction(sys), 10);
    sys.dyn.U = simplify_(-jacobian(sys.dyn.l_r, u), 10);

    sys.dyn.nu = simplify_(sys.dyn.l_r - sys.dyn.M*sys.pp, 10) - ...
                          sys.dyn.g - sys.dyn.f + sys.dyn.U*sys.u;
    
    % Control dynamic matrices
    sys.dyn.H = sys.dyn.M;
    sys.dyn.h = simplify_(sys.dyn.nu + sys.dyn.g + sys.dyn.f, 10);
    sys.dyn.Z = simplify_(sys.dyn.U);
    
    sys.dyn.W = simplify_(chol(sys.dyn.H, 'lower', 'nocheck'), 10);
end
