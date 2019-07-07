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

    % Left side of dynamic equation
    leqdyns = ddt_dL_dqp - dL_dq + dF_dqp;
    
    % Right side of dynamic equation
    reqdyns = Fq;

    % Dynamic equation respective to generalized coordinate qi
    sys.l_r = leqdyns - reqdyns;
    sys.leqdyns = leqdyns;
    sys.reqdyns = reqdyns;
    sys.eqdyns = leqdyns == reqdyns;
end