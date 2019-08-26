function [imag_idx, conj_idxs] = find_conjs(eigs)
% Description: Provide eigenvalues and return the conjugate without
% repetition
% Input [complex]: Eigenvalues
% 0utput:
%   - [list]: Eigenvalues indexes
%   - [cell]: Eigenvalues conjugate

    % Find complex numbers
    eig_imags = imag(eigs);
    idx_imags = find(eig_imags ~= 0)';
    
    n = length(idx_imags);
    
    conj_idxs = {};
    imag_idx = {};
    
    conj_ids = [];
    for idx = idx_imags'
        is_complex = idx == conj_ids;
        is_conj = any(is_complex);
        
        if(is_conj)
            continue;
        end
        
        conjs = eigs == conj(eigs(idx));
        conj_ids = [conj_ids, find(conjs)];
        
        % Complex numbers - either unique or repeated
        imags = eigs == eigs(idx);
        idx_imags = find(imags);
        
        imag_idx{end+1} = idx_imags;
        
        if(~isempty(idx_conj))
            conj_idxs{end+1} = idx_conj;
        else
            conj_idxs{end+1} = [];
        end
    end
end