function expr = simplify_(expr, timeout)
    if(nargin == 1)
        timeout = 10;
    end
    expr = simplify(expand(sym(expr)), 'Seconds', timeout);
end