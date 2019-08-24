function [imag_idx, conj_idxs] = find_conjs(eigs)
    eig_imags = imag(eigs);
    
    idx_imags = find(eig_imags ~= 0)';
    
    n = length(idx_imags);
    
    conj_idxs = {};
    imag_idx = [];
    
    repeated = [];
    for idx = idx_imags'
        if(any(find(idx == repeated)))
            continue;
        end
        
        idx_conj = find(eigs == conj(eigs(idx)));
        repeated = [repeated, idx_conj];
        
        % Remove elements from list
        for idx_ = idx_conj
            idx_imags(idx_) = 0;
        end
        
        if(~isempty(idx_conj))
            conj_idxs{end+1} = idx_conj;
        else
            conj_idxs{end+1} = 0;
        end
        
        imag_idx = [imag_idx, idx];
    end
end