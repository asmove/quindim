function sys = dyn_matrices(sys, helper)
    u = sys.descrip.u;
    
    % Dynamic matrices of a mechanical system
    sys.dyn.M = simplify_(mass_matrix(sys, helper));
    sys.dyn.g = simplify_(gravitational(sys, helper));
    sys.dyn.f = simplify_(friction(sys, helper));
    sys.dyn.U = simplify_(-jacobian(helper.l_r, u));

    sys.dyn.nu = simplify_(helper.l_r - sys.dyn.M*sys.kin.pp) - ...
                          sys.dyn.g - sys.dyn.f + sys.dyn.U*sys.descrip.u;
    
    % Control dynamic matrices
    sys.dyn.H = sys.dyn.M;
    sys.dyn.h = simplify_(sys.dyn.nu + sys.dyn.g + sys.dyn.f);
    sys.dyn.Z = simplify_(sys.dyn.U);
    
    sys.dyn.W = simplify_(chol(sys.dyn.H, 'lower', 'nocheck'));
end
