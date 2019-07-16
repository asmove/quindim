function A = ctrb_canon(poles)
    n = length(poles);
    coeffs = poly(poles);
    coeffs = fliplr(coeffs(2:end));
    
    A = [zeros(n-1, 1), eye(n-1); -coeffs];
end