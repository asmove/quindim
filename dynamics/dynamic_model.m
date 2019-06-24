function sys = dynamic_model(sys, method)
    
    % Default method: Lagrange
    switch nargin
        case 1
            method = 'lagrange';    
    end
    
    % Dynamic equations
    sys = eqdyns(sys, method);
    
    % Main matrices
    [sys.M, sys.g, sys.friction, sys.nu, sys.U, ...
     sys.H, sys.h, sys.Z, sys.W] =  dyn_matrices(sys);
    
    % Quasi-velocities
    sys.quasi_vel = sys.W.'*sys.qp;
 
    % Sytem behaviour
    qpps = sys.H\(sys.Z*sys.u - sys.h);
    qps = sys.qp;

    sys.f = [qps; qpps];
end
