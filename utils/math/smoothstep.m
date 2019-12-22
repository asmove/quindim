function func_val = smoothstep(t, T, y_begin, y_end, degree)
    x = t/T;
    
    func_val = 0;
    
    if((x >= 0)&&(x < 1))
        for k = 0:degree
            comb_1 = nchoosek(degree+k, k);
            comb_2 = nchoosek(2*degree+1, degree-k);
            func_val = func_val + comb_1*comb_2*(-x)^k;
        end
        
        func_val = x^(degree+1)*func_val;
        func_val = y_begin + (y_end - y_begin)*func_val;
    elseif(x>=1)
        func_val = y_end;
    else
        func_val = 0;
    end
end
