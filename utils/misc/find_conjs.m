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
    repeated_eigs = [];
    
    if(~isempty(idx_imags))
        for idx = idx_imags'
            if(any(eigs(idx) == eigs(repeated_eigs)) || ...
               any(conj(eigs(idx)) == eigs(repeated_eigs)))
                continue;
            end

            % Find conjugate numbers
            is_complex = idx == conj_ids;
            is_conj = any(is_complex);

            repeated_eigs = [repeated_eigs, find(eigs == eigs(idx))];

            if(is_conj)
                continue;
            end

            conjs = find(eigs == conj(eigs(idx)));

            conj_ids = [conj_ids, find(conjs)];

            % Complex numbers - either unique or repeated
            imags = eigs == eigs(idx);
            idx_imags = find(imags);

            imag_idx{end+1} = idx_imags;

            if(~isempty(conj_ids))
                conj_idxs{end+1} = conjs;
            else
                conj_idxs{end+1} = [];
            end
        end 
    end
end