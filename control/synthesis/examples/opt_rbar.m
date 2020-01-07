function rbar_val = opt_rbar(rbar_val, r_val, r, rbar, ...
                             drdt, drdt_val, eqs_i)
    r_symbs = [r; rbar; drdt];
    r_vals = [double(r_val); double(rbar_val)];
    
    rbar_val = subs(norm(eqs_i), r_symbs, r_vals);
    
    rbar_val
    
    rbar_val = double(rbar_val);
end