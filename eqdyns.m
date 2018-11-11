function sys = eqdyns(sys)
    syms u t;

    sys = lagrangian(sys);

    eqdyns = [];
    leqdyns = [];
    reqdyns = [];
    
    for i = 1:length(sys.q)
        qi = formula(sys.q{i});
        qpi = formula(sys.qp{i});
        Fqi = sys.Fq{i};
              
        % L derivative of L respective to q
        Lu = subs(sys.L, qi, u);
        dL_dqi = diff(Lu, u);
        dL_dqi = subs(dL_dqi, u, qi);
                
        % L derivative of L respective to qp
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
    
    sys.eqdyns = eqdyns;
    sys.reqdyns = reqdyns;
    sys.leqdyns = leqdyns;
    
end