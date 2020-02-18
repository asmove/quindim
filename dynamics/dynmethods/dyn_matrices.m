function sys = dyn_matrices(sys, helper)
    u = sys.descrip.u;
    
    % Nummerical energies 
    C = sys.kin.C;
    q = sys.kin.q;
    p = sys.kin.p{end};
    pp = sys.kin.pp{end};
    
    Cp = helper.Cp;
    
    % New and old time derivative variables
    qp_ = C*p;
    qpp_ = C*pp + Cp*p;
    
    qp = sys.kin.qp;
    qpp = sys.kin.qpp;
    
    % Dynamic matrices of a mechanical system
    sys.dyn.M = simplify_(mass_matrix(sys, helper));
    sys.dyn.g = simplify_(gravitational(sys, helper));
    sys.dyn.f_b = simplify_(friction(sys, helper));
    sys.dyn.f_k = simplify_(spring_force(sys, helper));
    sys.dyn.U = simplify_(-jacobian(helper.l_r, u));
    
    symbs_qp = [qp; qpp];
    symbs_p = [qp_; qpp_];
    
    temp = subs(C.'*(helper.ddt_dL_dqp - helper.dKdq), symbs_qp, symbs_p);
    sys.dyn.nu = simplify_(temp - sys.dyn.M*sys.kin.pp);
        
    % Control dynamic matrices
    sys.dyn.H = sys.dyn.M;
    
    sys.dyn.Hp = dmatdt(sys.dyn.H, q, C*p);
    
    sys.dyn.h = simplify_(sys.dyn.nu + sys.dyn.g + ...
                          sys.dyn.f_b + sys.dyn.f_k);
    sys.dyn.Z = simplify_(sys.dyn.U);
end
