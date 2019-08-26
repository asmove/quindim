function A = eig_to_matrix(eigs)
    A = [];

    [id_imags, id_conj_imags] = find_conjs(eigs);
    
    id_imags
    id_conj_imags
    
    % Verify inconsistencies on eigenvalues:
    % - Complex eigenvalues must have respective conjugate;
    for i = 1:length(id_imags)
        if(isempty(id_conj_imags{i}))
            error('There MUST be the complex and conjugate complex numbers both');
        end
    end
    
    A_imag = [];
    for id_imag = id_imags
        Ai_imag = [];
        
        imag_eig = eigs(id_imag);
        
        Aw = complex_jblock(imag_eig);
        
        % Repeated eigenvalues
        idx_imags = find(eigs == imag_eig);
        
        for i = 1:length(idx_imags)
            Ai_imag = blkdiag(Ai_imag, Aw);
        end
        
        idx_imag_ = find(id_imags == id_imag);
        eigs(id_imags) = [];
        
        eigs(conj(eigs) == imag_eig) = [];
        
        if(length(idx_imag_) > 1)
            % ordan block for imaginary numbers
            for i = 1:length(idx_imag_) 
                Ai_imag(i:i+1, i+2:i+3) = eye(2);
            end
        end
        
        % Imaginary blocks
        A_imag = blkdiag(A_imag, Ai_imag);
    end
    
    A = blkdiag(A, A_imag);
    
    for eig_ = eigs
        idx_eigs = find(eigs == eig_);
        
        Ai_I = eig_;
            
        for i = 1:length(idx_eigs)
            A = blkdiag(A, Ai_I);
        end
    end
    
end