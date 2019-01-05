function is_sing = is_singularity(mechanism, q)
    [A, C, ~] = coupling_matrixC(mechanism, q);
    P = [C.'; A];
    is_sing = rank(P) == length(q);
end