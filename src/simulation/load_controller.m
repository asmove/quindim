function [] = load_controller(model_name, kwargs)
    outputs = kwargs.outputs;
    vars = kwargs.vars;
    paths = kwargs.paths;
    fun_names = kwargs.fun_names;
    expr_syms = kwargs.expr_syms;
    
    for i = 1:length(paths)
        paths_i = paths{i};
        expr_sym = expr_syms{i};
        output = outputs{i};
        vars_i = vars{i};
        fun_name = fun_names{i};
        
        load_simblock(model_name, paths_i, fun_name, ...
                      expr_sym, vars_i, output);
    end
    
    save_system(model_name, [], 'OverwriteIfChangedOnDisk',true);
    close_system(model_name);
end

