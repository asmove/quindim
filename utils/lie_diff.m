function L_f_g = lie_diff(f, g, x)
    size(f)
    size(g)
    size(x)
    size(jacobian(g, x))
    L_f_g = jacobian(g, x)*f;
end