function sim = gen_sim(sys, q_p, u, n)
    
    persistent H C Cp h Z;
    
    if(isempty(H))
        H = my_subs(sys.dyn.H, sys.descrip.syms, sys.descrip.model_params);
    end
    
    if(isempty(C))
        C = my_subs(sys.kin.C, sys.descrip.syms, sys.descrip.model_params);
    end
    
    if(isempty(Cp))
        Cp = my_subs(sys.kin.Cp, sys.descrip.syms, sys.descrip.model_params);
    end
    
    if(isempty(h))
        h = my_subs(sys.dyn.h, sys.descrip.syms, sys.descrip.model_params);
    end
    
    if(isempty(Z))
        Z = my_subs(sys.dyn.Z, sys.descrip.syms, sys.descrip.model_params);
    end

    q = q_p(1:n);
    p = q_p(n+1:end);
    
    C = sys.kin.C;
    Cp = sys.kin.Cp;
    
    qp_sym = [sys.kin.q; sys.kin.p{end}];
    
    H = my_subs(H, [sys.kin.q; sys.kin.p], q_p);
    h = my_subs(h, [sys.kin.q; sys.kin.p], q_p);
    
    H_num = my_subs(H, qp_sym, q_p);
    pp = my_subs(inv(H_num)*(-h + Z*u), qp_sym, q_p);
    
    sim.q = q;
    sim.qp = my_subs(C*p, [sys.kin.q; sys.kin.p], q_p);
    sim.qpp = Cp*p + C*pp; 
    
    sim.p = p;
    sim.pp = pp;
end