function Delta = lie_coupled_matrix(f, G, y, x)
    [deltas, ~] = nreldegs(f, G, y, x);
    p = length(y);
    [~, m] = size(G);
    
    Delta = sym(zeros(p, m));
    
    if(p ~= m)
       error('Number of inputs MUST be equal to outputs!'); 
    end
    
    for i = 1:p
        delta_i = deltas(i);
        
        j = 0;
        hi = y(i);
        
        % i-th Lie derivative for h respective to f
        lie_i_f_hi = hi;
        
        for j = 1:m
            gj = G(:, j);
            
            lie_j_f_hi = hi;
            
            for k = 1:delta_i-1
                lie_j_f_hi = lie_diff(f, lie_j_f_hi, x);    
            end
            
            lie_j_f_hi = lie_diff(gj, lie_j_f_hi, x);
            
            Delta(i, j) = lie_j_f_hi;
        end
    end
end