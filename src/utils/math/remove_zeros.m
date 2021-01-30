function A_nonzero = remove_zeros(A)
    n = numel(A);
    
    A_flatten = reshape(A, [1, n]);

    A_nonzero = [];
    for k = 1:n
        is_symvar = ~isempty(symvar(A_flatten(k)));
        
        if(is_symvar)
            isnonnull_elem = true;
        else
            isnonnull_elem = ~boolean(eval(42*A_flatten(k) == 0));
        end
        
        if(isnonnull_elem)
            A_nonzero = [A_nonzero, A_flatten(k)];
        end

    end
end