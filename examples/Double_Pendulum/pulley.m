function sys = pulley()        
    % Pulley conversion
    syms xp wm_p Tau_p F real;
    syms D;
          
    sys.u = [wm_p; Tau_p];
    sys.y = [xp; F];
    A = [D/2, 0; 0, 2/D];
    sys.transform = @(u) A*u;
    sys.transform_1 = @(y) A\y;
    
    sys.states = [];
    
    % System symbolics
    sys.syms = D;
end