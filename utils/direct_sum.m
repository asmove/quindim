function B = direct_sum(As)
    B = [];
    for A = As
        A = A{1};
        B = blkdiag(B, A);
    end
end