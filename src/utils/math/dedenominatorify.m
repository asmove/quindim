function Cnew = dedenominatorify(C, x)
    [~, m] = size(C);
    Cnew = C;
    
    for k = 1:m
        c_k = C(:, k);
        
        [num, den] = numden(sym(c_k));
        
        % Remove numbers
        for l = 1:length(den)
            vars_l = symvar(den(l));
            no_vars = isempty(vars_l);
            
            has_x = false;
            for j = 1:length(vars_l)
                idx_vars_l = find(x == vars_l(j));
                if(~isempty(idx_vars_l))
                    has_x = true;
                end
            end
            
            if(no_vars || ~has_x)
                den(l) = 0;
            end
        end        
        den = nonzeros(den);
        
        dens = unique(den);
        dens_search = dens;
        
        if(~isempty(dens))
            for i = 1:length(dens)
                n_i = dens(i);
                
                mmc = [];
                if(~isempty(dens_search))
%                     for d_i = dens_search
%                         d_i = d_i(1);
%                         [~, den_i] = numden(simplify_(n_i/d_i));
% 
%                         if(den_i == 1)
%                             mmc = [mmc; n_i];
%                         end
%                     end 
                    
                    mmc = dens;
                    mmc = unique(mmc);
                    mmc = prod(mmc);

                    dens_search = dens(i+1:end);
                end
            end
            mmc = prod(unique(dens));
            c_k = mmc*c_k;
            
            Cnew(:, k) = c_k;
    end
end