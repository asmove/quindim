function sys = lagrange_eqdyn(sys)
    % Generalized coordinates and velocities
    q = sys.descrip.q;
    qp = sys.descrip.qp;

    % Number of bodies in the system
    n = length(sys.bodies);
    bodies = sys.bodies;
    
    % System energy componentes
    sys.dyn.K = 0;
    sys.dyn.P = 0;
    sys.dyn.L = 0;
    sys.dyn.F = 0;
        
    % Kinetic, Potential, Lagrangian and Rayleigh of the bodies
    for i = 1:n
       [L, K, P] = lagrangian(bodies(i), sys.gravity);
       F = rayleigh_energy(bodies(i));
       
       body_dyn = sys.descrip.bodies(i).dyn;
       
       % Required energy components
       body_dyn.L = L;
       body_dyn.K = K;
       body_dyn.P = P;
       body_dyn.F = F;
       
       % System energy components
       sys.dyn.K = sys.dyn.K + K;
       sys.dyn.P = sys.dyn.P + P;
       sys.dyn.L = sys.dyn.L + L;
       sys.dyn.F = sys.dyn.F + F;
       
       sys.descrip.bodies(i).dyn = body_dyn;
    end
    
    % Total system energy
    sys.dyn.total_energy = sys.dyn.K + sys.dyn.P - sys.dyn.F;
    
    % Dynamic equations of the system   
    L = sys.dyn.L;
    F = sys.dyn.F;
    Fq = sys.Fq;
        
    % Derivative of L respective to q
    dL_dq = jacobian(L, q).';
       
    % Derivative of L respective to qp
    dL_dqp = jacobian(L, qp).';
    
    % Derivative of F respective to qp
    dF_dqp = jacobian(F, qp).';
    
    % Nummerical energies 
    C = sys.C;
    p = sys.p;
    pp = sys.pp;
    
    sys.dyn.K = subs(sys.dyn.K, sys.qp, C*p);
    sys.dyn.F = subs(sys.dyn.F, sys.qp, C*p);
    sys.dyn.total_energy = subs(sys.dyn.total_energy, sys.qp, C*p);
    
    % qp and qpp in terms of quasi-velocities
    Cp = dmatdt(C, sys.q, qp);
    sys.Cp = Cp;
    
    % Generalized velocities derivaives
    % in term of quasi-velocities
    qp_ = C*sys.p;
    qpp_ = C*pp + Cp*p;
    
    qp = sys.qp;
    qpp = sys.qpp;
    
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
    sys.dyn.l_r = simplify_(leqdyns - reqdyns);
    sys.dyn.leqdyns = simplify_(leqdyns);
    sys.dyn.reqdyns = simplify_(reqdyns);
    sys.dyn.eqdyns = leqdyns == reqdyns;
    
    % Main matrices
    sys = dyn_matrices(sys);
end

