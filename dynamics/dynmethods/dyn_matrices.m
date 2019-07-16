function sys = dyn_matrices(sys)
    u = sys.u;
    
    % Dynamic matrices of a mechanical system
    sys.dyn.M = mass_matrix(sys);
    sys.dyn.g = gravitational(sys);
    sys.dyn.f = friction(sys);
    sys.dyn.U = -jacobian(sys.dyn.l_r, u);

    sys.dyn.nu = simplify(sys.dyn.l_r - sys.dyn.M*sys.pp, 'Seconds', 10) - ...
                          sys.dyn.g - sys.dyn.f + sys.dyn.U*sys.u;
    
    % Control dynamic matrices
    sys.dyn.H = sys.dyn.M;
    sys.dyn.h = sys.dyn.nu + sys.dyn.g + sys.dyn.f;
    sys.dyn.Z = sys.dyn.U;
    
    sys.dyn.W = chol(sys.dyn.H, 'lower', 'nocheck');
end
