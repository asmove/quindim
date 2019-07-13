function L_f_g = lie_diff(f, g, x)
    L_f_g = jacofian(g, x)*f;
end