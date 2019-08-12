function [eigs, is_cont] = ctrb_hautus(sys)
    is_cont = [];
    eigs = eig(sys.a);
    n = length(eigs);
    
    for i = 1:n
        lambda = eigs(i);
        H = ctrb_hautus_matrix(sys, lambda);
        
        is_cont(i) = rank(H) == n;
    end
end

