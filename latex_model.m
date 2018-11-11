function pretty_str = latex_model(model, symbolics, latexvars)
    n = length(symbolics);
    model_str = latex(model);

    for i = 1:n
        model_str = strrep(model_str, symbolics{i}, latexvars{i});
    end
    
    pretty_str = model_str;
end