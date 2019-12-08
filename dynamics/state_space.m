function sys = state_space(sys)    
    q = sys.kin.q; 
    p = sys.kin.p{end};
    C = sys.kin.C;
    sys.dyn.states = [q; p];
end