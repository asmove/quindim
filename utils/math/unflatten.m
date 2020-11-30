function A_unflatten = unflatten(A_flatten, dim)
    if(prod(dim) ~= numel(A_flatten))
        error(sprintf('Product of dim elements %d not equal to %d', prod(dim), numel(A_flatten)));
    end
    
    A_unflatten = reshape(A_flatten, dim);
end