function [A, B] = ctrb_canon(poles)
    n = length(poles);
    coeffs = ctrb_coeffs(poles);
    
    A = [zeros(n-1, 1), eye(n-1); -coeffs];
    B = [zeros(n-1, 1); 1];
end
