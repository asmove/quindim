function H = obsv_hautus_matrix(sys, s)
    n = length(sys.a);
    A = sys.a;
    C = sys.C;
    H = [s*eye(n) - A; C];
end