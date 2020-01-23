function sys = lagrange_eqdyn(sys)
    % Generalized coordinates and velocities
    q = sys.kin.q;
    qp = sys.kin.qp;

    % Number of bodies in the system
    n = length(sys.descrip.bodies);
    bodies = sys.descrip.bodies;
    
    % System energy componentes
    sys.dyn.K = 0;
    sys.dyn.P = 0;
    sys.dyn.L = 0;
    sys.dyn.F = 0;

    % Kinetic, Potential, Lagrangian and Rayleigh of the bodies
    for i = 1:n
       [L, K, P] = lagrangian(bodies{i}, sys.descrip.gravity);
       F = rayleigh_energy(bodies{i});
       
       % Required energy components
       body_dyn.L = L;
       body_dyn.K = K;
       body_dyn.P = P;
       body_dyn.F = F;
       
       sys.descrip.bodies{i}.dyn = body_dyn;
       
       % System energy components
       sys.dyn.K = sys.dyn.K + K;
       sys.dyn.P = sys.dyn.P + P;
       sys.dyn.L = sys.dyn.L + L;
       sys.dyn.F = sys.dyn.F + F;
    end
    
    % Total system energy
    sys.dyn.total_energy = sys.dyn.K + sys.dyn.P - sys.dyn.F;
    
    % Dynamic equations of the system   
    L = sys.dyn.L;
    K = sys.dyn.K;
    P = sys.dyn.P;
    F = sys.dyn.F;

    Fq = sys.descrip.Fq;
    
    % Derivative of L respective to q
    dL_dq = jacobian(L, q).';
    dK_dq = jacobian(K, q).';
       
    % Derivative of L respective to qp
    dL_dqp = jacobian(L, qp).';
    
    % Derivative of F respective to qp
    dF_dqp = jacobian(F, qp).';
    
    % Nummerical energies 
    C = collapse_C(sys.kin.Cs, qp);
    sys.kin.C = C;
    p = sys.kin.p{1};
    pp = sys.kin.pp{1};
    
    sys.dyn.P = simplify_(subs(sys.dyn.P, sys.kin.qp, C*p));
    sys.dyn.K = simplify_(subs(sys.dyn.K, sys.kin.qp, C*p));
    sys.dyn.F = simplify_(subs(sys.dyn.F, sys.kin.qp, C*p));
    sys.dyn.total_energy = simplify_(subs(sys.dyn.total_energy, ...
                                          sys.kin.qp, C*p));
    
    % qp and qpp in terms of quasi-velocities
    Cp = dmatdt(C, sys.kin.q, qp);
    Cp = subs(Cp, qp, C*p);
    sys.kin.Cp = Cp;
    
    % Generalized velocities derivaives
    % in term of quasi-velocities
    qp_ = C*p;
    qpp_ = C*pp + Cp*p;

    qp = sys.kin.qp;
    qpp = sys.kin.qpp;
    
    % L derivative of dL/dqp respective to t
    ddt_dL_dqp = dvecdt(dL_dqp, [q; qp], [qp; qpp]);
    
    % Left hand side of dynamic equation
    m_term = simplify_(ddt_dL_dqp - dL_dq + dF_dqp);
    leqdyns = simplify_(C.'*m_term);
    
    % Right hand side of dynamic equation
    reqdyns = simplify_(C.'*Fq);
    
    % Quick hack - Avoid non-substitution
    leqdyns = subs(leqdyns, [qp; qpp], [qp_; qpp_]);
    leqdyns = subs(leqdyns, [qp; qpp], [qp_; qpp_]);
    
    % Dynamic equation respective to generalized coordinate qi
    helper.l_r = simplify_(leqdyns - reqdyns);
    
    helper.leqdyns = simplify_(leqdyns);
    helper.reqdyns = simplify_(reqdyns);
    helper.dLdq = dL_dq;
    helper.dKdq = dK_dq;
    helper.Cp = Cp;
    helper.ddt_dL_dqp = ddt_dL_dqp;
    sys.dyn.eqdyns = helper.leqdyns == helper.reqdyns;
    
    % Main matrices
    sys = dyn_matrices(sys, helper);
end

