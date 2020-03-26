function refdyn_str = refdyn_params(sys, poles, rel_qqbar, is_int)
    
    [n, m] = size(sys.dyn.Z);    
    are_valid_poles(poles)
    
    if(is_int && (mod(length(poles), 2) ~= 0))
        error('If integrator is on use, number of poles os even!');
    end

    if(length(unique(poles)) ~= length(poles))
        error('There may not be repeated eigenvalues.');
    end
    
    q = sys.kin.q;
    p = sys.kin.p{end};
    
    q_a = q(1:m);
    q_u = q(m+1:n);
    p_a = p(1:m);
    p_u = p(m+1:n);
    
    if(is_int)
        [imag_idx, conj_idxs] = find_conjs(poles);
        
        n = length(poles);        
        D = equationsToMatrix(rel_qqbar, q);
        
        poles_aux = [];
        for i = 1:length(poles)
            imag_idx = cell2mat(imag_idx);
            conj_idxs = cell2mat(conj_idxs);
            
            if(~isempty(imag_idx) && ~isempty(conj_idxs))
                if(~ismember(imag_idx, i) && ~ismember(conj_idxs, i))
                    poles_aux(end+1) = poles;
                end
            else
                poles_aux(end+1) = poles(i);
            end
        end
        
        n_aux = length(poles_aux)/2;
        
        poles_p = [poles(imag_idx); poles_aux(1:n_aux)];
        poles_m = [poles(conj_idxs); poles_aux(n_aux+1:end)];
        
        D_p = eig_to_matrix(poles_p);
        D_m = eig_to_matrix(poles_m);
        
        B = -(D_p^2 - D_m^2)*inv(D_p - D_m);
        C = -(D_p + B)*D_p;
        
        alpha_ = D;
        lambda_ = D*B;
        mu_ = D*C;

        refdyn_str.alpha = alpha_; 
        refdyn_str.lambda = lambda_; 
        refdyn_str.mu = mu_; 
    else
        D = equationsToMatrix(rel_qqbar, q);
    
        % Convergence on the manifold
        C = eig_to_matrix(poles);
        
        alpha_ = D;
        lambda_ = -C*D;
        
        refdyn_str.alpha = alpha_; 
        refdyn_str.lambda = lambda_; 
    end
end
