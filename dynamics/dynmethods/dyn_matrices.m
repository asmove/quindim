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
    sys.dyn.M = mass_matrix(sys, helper);
    sys.dyn.g = gravitational(sys, helper);
    sys.dyn.f_b = friction(sys, helper);
    sys.dyn.f_k = spring_force(sys, helper);
        
    symbs_qp = [qp; qpp];
    symbs_p = [qp_; qpp_];
    
    M = sys.dyn.M;
    
    sys.dyn.nu = helper.ddt_dL_dqp - helper.dKdq - sys.dyn.M*sys.kin.qpp;
    
    % Control dynamic matrices
    sys.dyn.H = C.'*M*C;
    sys.dyn.Hp = dmatdt(sys.dyn.H, q, C*p);
    
    sys.dyn.h = my_subs(C.'*(sys.dyn.nu + sys.dyn.g + ...
                     sys.dyn.f_b + sys.dyn.f_k), symbs_qp, symbs_p);
    sys.dyn.Z = equationsToMatrix(helper.reqdyns, u);
    
    n = length(sys.dyn.H);
    m = length(sys.descrip.u);
    
    if(isempty(sys.dyn.Z))
        sys.dyn.Z = zeros(n, m);
    end
end
