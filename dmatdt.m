function dAdt = dmatdt(A, q, qp)
    [~, n] = size(A);
    
    dAdt = [];    
    for i = 1:n
        dAdt = [dAdt, dvecdt(A(:, i), q, qp)];
    end
end