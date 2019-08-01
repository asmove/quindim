function reldeg_struct = nreldegs(f, G, y, x)
    % Array sizes
    p = length(y);
    [~, m] = size(G);
    
    % Relative degrees
    deltas = [];
    
    % Required term on exact linearization
    phis = sym([]);
    
    % Coupling matrix
    Delta = sym([]);
    
    % Coordinate transformation 
    transfs = sym([]);
    
    for i = 1:p
        j = 0;
        is_equal_zero = true;
        hi = y(i);
        
        % i-th Lie derivative for h respective to f
        lie_i_f_hi = hi;
        
        % Search for relative degree
        while(is_equal_zero)
            
            % Iteration relative degree
            j = j + 1;
            transfs = [transfs; lie_i_f_hi];
            
            % Lie of (i-th Lie derivative of hi respective f) respective to G
            lie_G = sym([]);
            for k = 1:m
                gk = G(:, k);
                lie_gk = simplify_(lie_diff(gk, lie_i_f_hi, x));
                lie_G(end+1) = lie_gk;
            end
            
            if(~isempty(symvar(lie_G)))
                if(m == p)
                    Delta = [Delta; lie_G];
                end
                
                deltas(end+1) = j;
                break;
            elseif(all(all(double(lie_G))))
                if(m == p)
                    Delta = [Delta; lie_G];
                end
                
                deltas(end+1) = j;
                break;
            end
            
            lie_i_f_hi = simplify_(lie_diff(f, lie_i_f_hi, x));
        end
        
        % Vector with Lie derivative
        lie_delta_f_hi = lie_diff(f, lie_i_f_hi, x);
        phis = [phis; lie_delta_f_hi];
    end
    
    Delta = simplify_(Delta);
    phis = simplify_(phis);

    reldeg_struct.deltas = deltas;
    reldeg_struct.transfs = transfs;
    reldeg_struct.phis = phis;
    reldeg_struct.Delta = Delta;
end