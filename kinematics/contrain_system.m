function sys = contrain_system(sys, A)
    % Coupling matrix
    C = simplify_(null(A));
    
    % qp and qpp in terms of quasi-velocities
    sys.Cp = dmatdt(C, sys.q, sys.qp);
    
    
end