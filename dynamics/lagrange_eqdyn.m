function sys = lagrange_eqdyn(sys)
    % Number of bodies in the system
    n = length(sys.bodies);
    bodies = sys.bodies;
    
    % System energy componentes
    sys.K = 0;
    sys.P = 0;
    sys.L = 0;
    sys.F = 0;
        
    % Kinetic, Potential, Lagrangian and Rayleigh of the bodies
    for i = 1:n
       [L, K, P] = lagrangian(bodies(i), sys.gravity);
       F = rayleigh_energy(bodies(i));
              
       % Required energy components
       sys.bodies(i).L = L;
       sys.bodies(i).K = K;
       sys.bodies(i).P = P;
       sys.bodies(i).F = F;
       
       % System energy components
       sys.K = sys.K + K;
       sys.P = sys.P + P;
       sys.L = sys.L + L;
       sys.F = sys.F + F;
    end

    % Total system energy
    sys.total_energy = sys.K + sys.P - sys.F;
    
    % Dynamic equations of the system   
    L = sys.L;
    F = sys.F;
    Fq = sys.Fq;
    
    q = sys.q;
    qp = sys.qp;
    x = [sys.q; sys.qp];
    xp = [sys.qp; sys.qpp];
       
    % Derivative of L respective to q
    dL_dq = jacobian(L, q).';
       
    % Derivative of L respective to qp
    dL_dqp = jacobian(L, qp).';

    % L derivative of dL/dqp respective to t
    ddt_dL_dqp = dvecdt(dL_dqp, x, xp);

    % Derivative of F respective to qp
    dF_dqp = jacobian(F, qp).';
        
    is_holonomic = isfield(sys, {'hol_constraints'});
    is_unholonomic = isfield(sys, {'unhol_constraints'});
    
    % Unholonomic constraitns
    if(is_unholonomic && ~is_holonomic)
        constraints = sys.unhol_constraints;
        A = jacobian(constraints, sys.qp);
        C = simplify(null(A));
        
    % Holonomic constraitns
    elseif(is_holonomic && ~is_unholonomic)
        constraints = sys.hol_constraints;
        A = jacobian(constraints, sys.q);
        C = simplify(null(A));
        
    % Both
    elseif(is_holonomic && is_unholonomic)
        constraints = sys.hol_constraints;
        A_hol = jacobian(constraints, sys.q);
        A_unhol = jacobian(constraints, sys.qp);
        
        A = [A_hol; A_unhol];
        C = simplify(null(A));

    else
        A = [];
        C = eye(length(sys.q));
        warning('When neither holonomic nor unholonomic, it presents unexpected behaviour.');
    end
    
    % Constraint velocity matrix and its complementary
    sys.A = A;
    sys.C = C;

    % Constraint velocity matrix and its complementary
    sys.Cp = dmatdt(sys.C, sys.q, sys.qp);
    
    % Left hand side of dynamic equation
    leqdyns = C.'*(ddt_dL_dqp - dL_dq + dF_dqp);
    
    % Right hand side of dynamic equation
    reqdyns = C.'*Fq;
    
    qp = sys.C*sys.p;
    sys.Cp = dmatdt(C, sys.q, qp);
    
    qpp = sys.C*sys.pp + sys.Cp*sys.p;
    
    leqdyns = subs(leqdyns, sys.qpp, qpp);
    
    % Dynamic equation respective to generalized coordinate qi
    sys.l_r = leqdyns - reqdyns;
    sys.leqdyns = leqdyns;
    sys.reqdyns = reqdyns;
    sys.eqdyns = leqdyns == reqdyns;
    
    % Main matrices
    sys =  dyn_matrices(sys);
    
end