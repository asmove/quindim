function Cnew = dedenominatorify(C)
    [~, m] = size(C);
    Cnew = C;

    for k = 1:m
        c_k = C(:, k);
        
        [num, den] = numden(sym(c_k));
        
        den(simplify_(den - 1) == 0) = [];
        
        dens = den;
        if(~isempty(dens))
            for i = 1:length(dens)
                n_i = dens(i);

                dens_search = dens;
                dens_search(dens_search == n_i) = [];

                mmc = [n_i];
                while(length(dens_search)~=1)
                    if(~isempty(dens_search))
                        for d_i = dens_search
                            [num_i, den_i] = numden(simplify_(n_i/d_i));

                            if(den_i == 1)
                                mmc = [nums; num_i];
                            end
                        end                    
                    end

                    dens_search = mmc;
                end
            end
            
            c_k = mmc*c_k;
        
            Cnew(:, k) = c_k;
        end
    end
end