function [alpha_a, alpha_u, ...
          lambda_a, lambda_u] = alpha_lambda(sys, poles, rel_qqbar)
    
    [n, m] = size(sys.dyn.Z);
      
    if(length(poles) ~= m)
        error('Number of poles MUST be equal to number of inputs');
    end
    
    q = sys.kin.q;
    p = sys.kin.p;
    
    q_a = q(1:m);
    q_u = q(m+1:n);
    p_a = p(1:m);
    p_u = p(m+1:n);
    
    D = equationsToMatrix(rel_qqbar, q);
    
    % Convergence on the manifold
    C = eig_to_matrix(poles);
    
    if(length(sys.kin.C) ~= 1)
        [a, ~] = size(sys.kin.C{1});
        
        Cs = eye(a);
        for i = 1:length(sys.kin.C)
            Cs = Cs*sys.kin.C{i};
        end
    else
        Cs = sys.kin.C;
    end
    
    alpha_ = D;
    lambda_ = -C*D;
    
    alpha_a = alpha_(1:m, 1:m);
    alpha_u = alpha_(1:m, m+1:end);
    
    lambda_a = lambda_(1:m, 1:m);
    lambda_u = lambda_(1:m, m+1:end);
end