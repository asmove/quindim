function expr = simplify_(expr, timeout)
   expr = simplify(expand(sym(expr)));
end