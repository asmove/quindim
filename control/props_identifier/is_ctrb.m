function is_c = is_ctrb(A, B)
    n = length(A);
    is_c = rank(ctrb(A, B)) == n;
end