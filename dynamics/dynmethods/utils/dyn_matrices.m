function sys = dyn_matrices(sys)
    u = sys.u;
    
    % Dynamic matrices of a mechanical system
    sys.M = mass_matrix(sys);
    sys.g = gravitational(sys);
    sys.f = friction(sys);
    sys.U = -jacobian(sys.l_r, u);

    sys.nu = simplify(sys.l_r - sys.M*sys.pp, 'Seconds', 10) - ...
             sys.g - sys.f + sys.U*sys.u;
    
    % Control dynamic matrices
    sys.H = sys.M;
    sys.h = sys.nu + sys.g + sys.f;
    sys.Z = sys.U;
    
    sys.W = chol(sys.H, 'lower', 'nocheck');
end
