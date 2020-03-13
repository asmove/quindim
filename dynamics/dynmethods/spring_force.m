function F_k = spring_force(sys, helper)
    ks = [];
    for body = sys.descrip.bodies
        body = body{1};
        n_k = length(body.springs);
        springs_i = body.springs;

        if(~isempty(springs_i))
            springs_i = springs_i{1};
        end
        
        for i = 1:n_k
            ks = [ks; springs_i.k];
        end
    end
    
    ks = unique(ks);
    
    F_k = equationsToMatrix(helper.l_r, ks)*ks;
    F_k = simplify_(F_k);
end
