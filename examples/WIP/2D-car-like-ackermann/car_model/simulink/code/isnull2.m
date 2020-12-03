function is_nonnull = isnull2(A)
    
    [idxs, idys] = find(A ~= 0);
        
    is_nonnull = zeros(size(A));
    
    for i = 1:length(idxs)
        idx = idxs(i);
        idy = idys(i);
        is_nonnull(idx, idy) = 1;
    end
end