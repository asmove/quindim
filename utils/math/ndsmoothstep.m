function func_val = ndsmoothstep(t, T, y_begin, y_end, degree, n_diffs)
    x = t/T;
    
    func_val = 0;
    
    if((x >= 0)&&(x <= 1))        
        if(n_diffs <= degree+1)
            for k = 0:degree
                func_val = func_val + ...
                           dsmoothstep_monome(x, k, degree, n_diffs, T);
            end

            func_val = x^(degree+1-n_diffs)*func_val;
        
        else
            for k = 0:degree-n_diffs
                func_val = func_val + ...
                           dsmoothstep_monome(x, k, degree, n_diffs, T);
            end
        end
        
        func_val = (y_end - y_begin)*func_val;

    else
        func_val = zeros(size(y_end));
    end
    
    func_val = simplify_(func_val);
end

