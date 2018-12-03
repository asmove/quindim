function [eqdyns, sys] = lagrange_eqdyn(sys)
    syms u t;
    
    % Number of bodies in the system
    n = length(sys.bodies);
    bodies = sys.bodies;
    
    % System energy componentes
    sys.K = 0;
    sys.U = 0;
    sys.L = 0;
    sys.F = 0;
    
    % Lagrangian of the bodies
    for i = 1:length(n)
       [L, K, U] = lagrangian(sys.bodies{i});
       F = rayleigh_energy(bodies{i});
        
       % Required energy components
       sys.bodies{i}.L = L;
       sys.bodies{i}.K = K;
       sys.bodies{i}.U = U;
       sys.bodies{i}.F = F;
       
       % System energy components
       sys.K = sys.K + K;
       sys.U = sys.U + U;
       sys.L = sys.L + L;
       sys.F = sys.F + F;
    end
    
    % Dynamic equations of the system
    eqdyns = [];
    leqdyns = [];
    reqdyns = [];
    
    for i = 1:length(sys.q)
        qi = formula(sys.q{i});
        qpi = formula(sys.qp{i});
        Fqi = sys.Fq{i};
        
        % Derivative of L respective to q
        % Take note: varfun are not derivable
        Lu = subs(sys.L, qi, u);
        dL_dqi = diff(Lu, u);
        dL_dqi = subs(dL_dqi, u, qi);
                
        % Derivative of L respective to qp
        Lqu = subs(sys.L, qpi, u);
        dL_dqip = diff(Lqu, u);
        dL_dqip = subs(dL_dqip, u, qpi);

        % L derivative of dL/dqp respective to t
        ddt_dL_dqip = diff(dL_dqip, t);
        ddt_dL_dqip = subs(ddt_dL_dqip, sys.diffq, sys.varq);

        % F derivative of L respective to t
        Fu = subs(sys.F, qpi, u);
        
        dF_dqip = diff(Fu, u);
        dF_dqip = subs(dF_dqip, u, qpi);
        
        % Left side of dynamic equation
        leqdyn = ddt_dL_dqip - dL_dqi + dF_dqip;
        leqdyns = [leqdyns; simplify(leqdyn)];

        % Right side of dynamic equation
        reqdyn = Fqi;
        reqdyns = [reqdyns; reqdyn];
        
        % Dynamic equation respective to generalized coordinate qi
        eqdyn = leqdyn == reqdyn;
        eqdyns = [eqdyns; eqdyn];
    end
    
    % Right and left and dynamic equation itself
    sys.reqdyns = reqdyns;
    sys.leqdyns = leqdyns;
    sys.eqdyns = eqdyns;
end