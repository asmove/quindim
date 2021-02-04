function sys = iso_speeds(sys, T)
    n_p = length(sys.kin.p{end});
    
    if(~(length(T) == n_p))
        
    end
    
    C = sys.kin.C;
    C_ = simplify_(C*T);
    
    Jv = sys.dyn.Jv;
    Jw = sys.dyn.Jw;
    
    sys.kin.C = C_;
    sys.kin.Cs = {C_};
    sys.dyn.Jv = simplify_(Jv*T);
    sys.dyn.Jw = simplify_(Jw*T);
end