function x_latex = latexify_vars(x)
    x_latex = {};
    for i = 1:length(x)
        x_i = x(i);
        x_ilatex = ['\mathrm{', char(x_i), '}'];
        x_latex{end+1} = {x_ilatex};
    end
end