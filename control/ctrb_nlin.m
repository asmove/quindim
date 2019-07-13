function ctrb_ = ctrb_nlin(sys)
    f = sys.f;
    g = sys.g;
    n = length(f);
    [~, m] = size(g);
    
    ctrb_ = [sys.g];
    brack_1 = sys.g;
    for i = 1:n-1
        for j = 1:m
            brack_i_1 = brack_1(:, j);
            brack_i =  bracket(sys.f, brack_i_1, sys.q);
            ctrb_ = [ctrb_, brack_i];
        end
    end
end

function brack =  bracket(f, g, q)
    brack = jacobian(g, q).'*f - jacobian(f, q).'*g;
end