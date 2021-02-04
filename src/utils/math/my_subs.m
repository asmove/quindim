function expr_subs = my_subs(expr, symbs, vals)
    idxs = find_elems(symvar(sym(expr)), symbs);
    
    idxs = idxs(idxs~= 0);
    expr_subs = subs(expr, symbs(idxs), vals(idxs));
    
    if(isempty(symvar(expr_subs)))
        expr_subs = double(expr_subs);
    else
        expr_subs = vpa(expr_subs);
    end
end