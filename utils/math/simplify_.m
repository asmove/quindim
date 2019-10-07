function expr_simp = simplify_(exprs, timeout)
    if(nargin == 1)
        timeout = 10;
    end
    
    expr_simp = [];
    
    if(iscell(exprs))
        for expr = exprs
            expr = simplify(expand(sym(expr)), ...
                            'Seconds', timeout, ...
                            'Criterion', 'preferReal');
            expr_simp = [expr_simp, expr];
        end
    else
        expr_simp = simplify(expand(sym(exprs)), ...
                        'Seconds', timeout, ...
                        'Criterion', 'preferReal');
    end
end