function monome = dsmoothstep_monome(x, k, degree, n_diffs, T)
    comb_1 = nchoosek(degree+k, k);
    comb_2 = nchoosek(2*degree+1, degree-k);
    comb_3 = nchoosek(degree + k + 1, n_diffs);
    monome = (-1)^k*(1/T)^n_diffs*comb_1*comb_2*comb_3*x^k;
end