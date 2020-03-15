function refdyn_str = refdyn_params(sys, poles, rel_qqbar, is_int)
    
    [n, m] = size(sys.dyn.Z);
      
    if(length(poles) ~= m)
        error('Number of poles MUST be equal to number of inputs');
    end
    
    q = sys.kin.q;
    p = sys.kin.p{end};
    
    q_a = q(1:m);
    q_u = q(m+1:n);
    p_a = p(1:m);
    p_u = p(m+1:n);
    
    D = equationsToMatrix(rel_qqbar, q);
    
    % Convergence on the manifold
    C = eig_to_matrix(poles);

    alpha_ = D;
    lambda_ = -C*D;
    mu_ = ;
    
    refdyn_str.alpha = alpha_; 
    refdyn_str.lambda = lambda_; 
     
end
