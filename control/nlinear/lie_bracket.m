function bracket = lie_bracket(f, g, x)
    bracket = jacobian(g, x)*f - jacobian(f, x)*g;
end