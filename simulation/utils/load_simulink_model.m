function [] = load_simulink_model(model_name, paths, fun_names, Outputs, expr_syms, vars)
% Description: 
% Inputs:
%   model_name:
%   paths: 
%   fun_names:  
%   Outputs:  
%   expr_syms:  
%   vars:
% 
% Outputs:
% 

    for expr_sym = expr_syms
        if(isempty(expr_sym))
            expr_sym = sym(0);
        end
    end

    n = length(paths);

    open_system(model_name);
    sf = Simulink.Root;

    for i = 1:n
        path = [model_name, '/', paths{i}];
        block = sf.find('Path', path, '-isa','Stateflow.EMChart');

        % Properties of the file
        expr_sym = expr_syms{i};
        output = Outputs{i};
        vars_i = vars{i};
        fun_name = fun_names{i};

        matlabFunction(expr_sym, 'File', fun_name, ...
                                      'Vars', vars_i, ...
                                      'Outputs', output);

        fname = [fun_name, '.m'];
        file_handle = fopen(fname, 'r');

        % Title
        f_call = fgets(file_handle);
        script_body = f_call;

        tline = fgets(file_handle);

        while(strcmp(tline(1), '%'))
            tline = fgets(file_handle);
        end

        % Script body
        tline = fgets(file_handle);
        while(tline ~= -1)
            script_body = [script_body newline tline];
            tline = fgets(file_handle);
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

    save_system(model_name);
    close_system(model_name);
end