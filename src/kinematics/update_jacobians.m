function sys = update_jacobians(sys, C)
    sys.dyn.Jv = sys.dyn.Jv*C;
    sys.dyn.Jw = sys.dyn.Jw*C;
    
    for i = 1:length(sys.descrip.bodies)
        Jvi = sys.descrip.bodies{i}.Jv;
        Jwi = sys.descrip.bodies{i}.Jw;
        
        Jvi = Jvi*C;
        Jwi = Jwi*C;
        
        sys.descrip.bodies{i}.Jv = Jvi;
        sys.descrip.bodies{i}.Jw = Jwi;
    end
end