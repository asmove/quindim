function isnull_buffer = elem_isnull(A)
% Description: set the element to TRUE if not null
% and FALSE if null
% Input : Tensor A
% Output: Tensor isnull_buffer

    n = numel(A);
    
    A_flatten = reshape(A, [1, n]);
    isnull_buffer = zeros(1, n);
    
    for i = 1:length(A_flatten)
        is_symvar = isempty(symvar(A_flatten(i)));
        isnull_elem = vpa(42*A_flatten(i) == 0);
        
        isnull_buffer(i) = isnull_elem && is_symvar;
    end
    
    isnull_buffer = reshape(isnull_buffer, size(A));
end