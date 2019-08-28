function combs_k = comb_vec(a, b)
    combs = combvec(a, b);

    [m, n] = size(combs);

    combs_c = {};
    for i = 1:n
        combs_c{end+1} = combs(:, i);
    end

    combs_k = {};
    for k = 1:n-1
        combs_k{end+1} = combntns(combs_c, k);
    end
end