function sys = lagrange_eqdyn(sys)
    
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
       
       % Required energy components
       sys.bodies(i).dyn.L = L;
       sys.bodies(i).dyn.K = K;
       sys.bodies(i).dyn.P = P;
       sys.bodies(i).dyn.F = F;
       
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
    F = sys.dyn.F;
    Fq = sys.Fq;
    
    q = sys.q;
    qp = sys.qp;
    x = [sys.q; sys.qp];
    
    % Derivative of L respective to q
    dL_dq = jacobian(L, q).';
       
    % Derivative of L respective to qp
    dL_dqp = jacobian(L, qp).';
    
    [A, C] = constraint_matrices(sys);
    
    % Derivative of F respective to qp
    dF_dqp = jacobian(F, qp).';
    
    % Constraint velocity matrix and its complementary
    sys.dyn.A = A;
    sys.dyn.C = C;
    
    % qp and qpp in terms of quasi-velocities
    qp = sys.dyn.C*sys.p;
    sys.dyn.Cp = dmatdt(C, sys.q, qp);
    qpp = sys.dyn.C*sys.pp + sys.dyn.Cp*sys.p;
    
    xp = [qp; qpp];
    
    % L derivative of dL/dqp respective to t
    ddt_dL_dqp = dvecdt(dL_dqp, x, xp);
    
    % Left hand side of dynamic equation
    m_term = simplify(ddt_dL_dqp - dL_dq + dF_dqp, 'Seconds', 5);
    leqdyns = simplify(C.'*m_term, 'Seconds', 5);
    
    % Right hand side of dynamic equation
    reqdyns = simplify(C.'*Fq, 'Seconds', 5);
    
    % Dynamic equation respective to generalized coordinate qi
    sys.dyn.l_r = simplify(leqdyns - reqdyns, 'Seconds', 5);
    sys.dyn.leqdyns = leqdyns;
    sys.dyn.reqdyns = reqdyns;
    sys.dyn.eqdyns = leqdyns == reqdyns;
    
    % Main matrices
    sys = dyn_matrices(sys);
end

function [A, C] = constraint_matrices(sys)
    is_contrained = sys.is_constrained;
    is_holonomic = isfield(sys, {'hol_constraints'});
    is_unholonomic = isfield(sys, {'unhol_constraints'});
    
    % Unholonomic constraitns
    if(is_contrained)
        if(is_unholonomic)
            constraints = sys.unhol_constraints;
            A = jacobian(constraints, sys.qp);
            C = simplify(null(A));

        % Holonomic constraitns
        elseif(is_holonomic)
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
            error('When constrained, the fields hol_constraints and unhol_constraints cannot be presented');
        end
    else
        A = [];
        C = eye(length(sys.q));
        if(is_holonomic || is_unholonomic)
            error('When unconstrained, the fields hol_constraints and unhol_constraints cannot be presented.');
        end
    end
end