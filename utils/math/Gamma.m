function gamma_ = Gamma(A, B, T)
    syms tau;
    C1 = expm(A*T);
    C2 = expm(-A*tau);
    C3 = B;
    C4 = int(C2, tau, 0, T);
    gamma_ = vpa(C1*C4*C3);
end