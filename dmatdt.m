function dAdt = dmatdt(A, q, qp)
    [m, n] = size(A);
    
    dAdt = zeros(m, n);    
    for i = 1:n
        dAdt(:, i) = dvecdt(A(:, i), q, qp)*qp.';
    end
end