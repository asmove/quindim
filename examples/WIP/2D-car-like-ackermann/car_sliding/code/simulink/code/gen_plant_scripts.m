function [] = gen_plant_scripts(sys, ctx)
    
    plant_struct = build_simulink_plant_struct(ctx.model_name, sys);
    
    % Read buffer
    nchar = 100000;
    
    open_system(ctx.model_path);
    sf = slroot;
    
    for i = 1:length(plant_struct.paths)
        paths_i = plant_struct.paths{i};
        
        % block = get_param(paths_i, 'MATLABFunctionConfiguration');
        block = sf.find('Path', paths_i, '-isa', 'Stateflow.EMChart');
        
        expr_sym = plant_struct.expr_syms{i};
        output = plant_struct.Outputs{i};
        vars_i = plant_struct.vars{i};
        fun_name = plant_struct.fun_names{i};
        
        expr_sym = vpa(expand(subs(expr_sym, plant_struct.symbs, plant_struct.vals)));
        
        matlabFunction(expr_sym, 'File', fun_name, ...
                                 'Vars', vars_i, ...
                                 'Outputs', output);
        
        fname = [fun_name, '.m'];
        file_handle = fopen(fname, 'r');

        f_call = fgets(file_handle, nchar);
        script_body = f_call;
        
        tline = fgets(file_handle, nchar);
        
        while(strcmp(tline(1), '%'))
            tline = fgets(file_handle, nchar);
        end
        
        tline = fgets(file_handle, nchar);
        while(tline ~= -1)
            script_body = [script_body newline tline];
            tline = fgets(file_handle, nchar);
        end
        
        script_body = [script_body newline 'end'];
        
        fclose(file_handle);
        delete(fname);
        
        file_handle = fopen(fname, 'w');
        fprintf(file_handle, '%s', script_body);    
        fclose(file_handle);
        
        block.Script = script_body;
        delete(fname);
    end
    
    save_system(ctx.model_path, [],'OverwriteIfChangedOnDisk',true);
    close_system(ctx.model_path);
end
    
