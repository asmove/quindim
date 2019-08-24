function new_symvars = add_symsuffix(symvars, suffix)
    new_symvars = sym(zeros(size(symvars)));
    for i = 1:length(symvars)
        items = [char(symvars(i)), suffix];
        new_symvars(i) = sym(items);
    end
end