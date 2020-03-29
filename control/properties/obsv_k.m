function Mo = obsv_k(A, C)
    n = length(A);

    Mo = C;

    for i = 2:n
        Mo = [Mo; C*A^(i-1)];
    end
end