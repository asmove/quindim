function sys = dynamic_model(sys, method)
    
    % Default method: Lagrange
    switch nargin
        case 1
            method = 'lagrange';    
    end

    sys = eqdyns(sys, method);
    [sys.M, sys.g, sys.friction, sys.nu, ...
     sys.H, sys.h, sys.Z] =  dyn_matrices(sys);
end