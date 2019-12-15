function is_p = is_positive(A)
    if(any(eig(A) < 0))
        error('The matrix is not positive!');
    end
end