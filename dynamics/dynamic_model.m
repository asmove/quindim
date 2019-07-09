function sys = dynamic_model(sys, method)
    
    % Default method: Lagrange
    switch nargin
        case 1
            method = 'lagrange';    
    end
    
    % Dynamic equations
    sys = eqdyns(sys, method);
end
