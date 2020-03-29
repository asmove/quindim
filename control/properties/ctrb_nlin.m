function ctrb_ = ctrb_nlin(f, G, x)
    n = length(f);
    [~, m] = size(G);
    
    ctrb_ = G;
    brack_1 = G;
    for i = 1:n-1
        for j = 1:m
            brack_i_1 = brack_1(:, j);
            brack_i =  lie_bracket(f, brack_i_1, x);
            ctrb_ = [ctrb_, brack_i];
        end
    end
end
