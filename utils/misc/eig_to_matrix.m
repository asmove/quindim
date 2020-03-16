function A = eig_to_matrix(eigs)
    A = [];

    [id_imags, ~] = are_valid_poles(eigs);
    
    A_imag = [];
    
    for id_imag = id_imags
        id_imags_ = id_imags{1};
        id_imag_ = id_imag{1};
        
        for id_imag = id_imag_
            % Remove elements of given value
            Ai_imag = [];
            
            imag_eig = eigs(id_imag);
            
            Aw = complex_jblock(imag_eig);
            
            % Repeated eigenvalues
            idx_imags = find(eigs == imag_eig);

            for i = 1:length(idx_imags)
                Ai_imag = blkdiag(Ai_imag, Aw);
            end
        end
            
        if(length(id_imag_) > 1)
            len_imag = length(id_imag_);
            
            % Jordan block for imaginary numbers
            for i = 1:len_imag-1
                Ai_imag(i:i+1, i+2:i+3) = eye(2);
            end
        end

        % Imaginary blocks
        A_imag = blkdiag(A_imag, Ai_imag);        
    end
    
    A = blkdiag(A, A_imag);
    
    imags_id = [];
    for id_imag = id_imags
        imags_id = [imags_id, id_imag{1}];
    end
    
    imags_ = [unique(eigs(imags_id)), unique(conj(eigs(imags_id)))];
    
    for imag_ = imags_
        if(isempty(imag_))
            break;
        end
        
        idxs = find(eigs == imag_);
        eigs(idxs) = [];
    end
    
    real_eigs = unique(eigs);
    
    len_reals = length(real_eigs);
    for i = 1:len_reals
        real_eig = real_eigs(i);
        eig_i = eigs(find(eigs == real_eig));
        
        Ai = diag(eig_i);
        
        len_eig_i = length(eig_i);
        if(len_eig_i > 1)
            for j = 1:len_eig_i - 1
                Ai(j, j+1) = 1;
            end
        end
        
        A = blkdiag(A, Ai);
    end
end