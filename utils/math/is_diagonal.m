function is_diagonal(A)
    if(any(any(diag(diag(A)) ~= A)))
        error('W MUST be diagonal!');
    end
end