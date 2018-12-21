function [eigs, is_cont] = obsv_hautus(sys)
    is_cont = [];
    eigs = eig(sys.a);
    n = length(eigs);
    
    for i = 1:n
        lambda = eigs(i);
        H = obsv_hautus_matrix(sys, lambda);
        
        is_cont(i) = rank(H) == n;
    end
end

