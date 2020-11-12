function sim = gen_sim(sys, q_p, u, n)
    
    persistent H C Cp h Z;
    
    if(isempty(H))
        H = subs(sys.dyn.H, ...
                 sys.descrip.syms, ...
                 sys.descrip.model_params);
    end
    
    if(isempty(C))
        C = subs(sys.kin.C, ...
                 sys.descrip.syms, ...
                 sys.descrip.model_params);
    end
    
    if(isempty(Cp))
        Cp = subs(sys.kin.Cp, ...
                  sys.descrip.syms, ...
                  sys.descrip.model_params);
    end
    
    if(isempty(h))
        h = subs(sys.dyn.h, ...
                  sys.descrip.syms, ...
                  sys.descrip.model_params);
    end
    
    if(isempty(Z))
        Z = subs(sys.dyn.Z, ...
                  sys.descrip.syms, ...
                  sys.descrip.model_params);
    end

    q = q_p(1:n);
    p = q_p(n+1:end);
    
    C = sys.kin.C;
    Cp = sys.kin.Cp;
    
    H = subs(H, [sys.kin.q; sys.kin.p], q_p);
    h = subs(h, [sys.kin.q; sys.kin.p], q_p);
    pp = subs(inv(H)*(-h + Z*u), [sys.kin.q; sys.kin.p], q_p);
    
    sim.q = q;
    sim.qp = subs(C*p, [sys.kin.q; sys.kin.p], q_p);
    sim.qpp = Cp*p + C*pp; 
    
    sim.p = p;
    sim.pp = pp;
end