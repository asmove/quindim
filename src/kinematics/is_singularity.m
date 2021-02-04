function is_sing = is_singularity(mechanism, q)
    C = coupling_matrixC(mechanism, q, zeros(size(q)));
    [A, ~] = coupling_matrixA(mechanism, q, zeros(size(q)));
    P = [C.'; A];
    is_sing = rank(P) < length(q);
end