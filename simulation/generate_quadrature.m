function combs = generate_quadrature(dim, L0, deps)
    % Create a space to work with and evaluate singularities and 
    % workspace
    combs = -L0:deps:L0;
    span_space = -L0:deps:L0;

    for j = 2:dim
        combs = combvec(combs, span_space);
    end
end