function isnonnull_buffer = elem_isnonnull(A)
% Description: set the element to TRUE if not null
% and FALSE if null
% Input : Tensor A
% Output: Tensor isnull_buffer

    n = numel(A);
    
    A_flatten = reshape(A, [1, n]);
    isnull_buffer = zeros(1, n);
    
    for k = 1:length(A_flatten)
        is_symvar = ~isempty(symvar(A_flatten(k)));
        
        if(is_symvar)
            isnonnull_elem = true;
        else
            expr_null= 42*A_flatten(k) == 0;
            isnonnull_elem = ~boolean(expr_null);
        end
        
        isnonnull_buffer(k) = (isnonnull_elem || is_symvar);
    end
    
    isnonnull_buffer = reshape(isnonnull_buffer, size(A));
end