function H = ctrb_hautus_matrix(sys, s)
    n = length(sys.a);
    A = sys.a;
    B = sys.b;
    H = [s*eye(n) - A, B];
end