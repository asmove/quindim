function [deltas, phis] = nreldegs(f, G, y, x)
    p = length(y);
    deltas = [];
    phis = sym([]);
    
    for j = 1:p
        i = 0;
        is_equal_zero = true;
        hi = y(j);
        
        % i-th Lie derivative for h respective to f
        lie_i_f_hi = hi;
        phis = [phis; lie_i_f_hi];
        
        [~, m] = size(G);
        
        while(is_equal_zero)
            % Lie of (i-th Lie derivative of hi respective f) respective to G
            lie_G = [];
            for i = 1:m
                gi = G(:, i);
                lie_gi = lie_diff(gi, lie_i_f_hi, x);

                % Non-empty array
                if(~isempty(symvar(lie_gi)))
                    is_equal_zero = false;
                    break;
                end
            end

            % MUST preempt the following statement to avoid counter increment
            if(~is_equal_zero)
                deltas(end+1) = i;
                break; 
            end
            
            lie_i_f_hi = lie_diff(f, lie_i_f_hi, x);

            i = i + 1;
        end
    end
end