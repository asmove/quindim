function L_f_g = lie_diff(f, g, x)
    L_f_g = jacobian(g, x)*f;
end
