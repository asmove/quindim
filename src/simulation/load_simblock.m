function [] = load_simblock(model_name, paths_i, fun_name, ...
                            expr_sym, vars_i, output)
    open_system(model_name);
    sf = Simulink.Root;

    block = sf.find('Path', paths_i, '-isa', 'Stateflow.EMChart');
    
    matlabFunction(expr_sym, ...
                   'File', fun_name, ...
                   'Vars', vars_i, ...
                   'Outputs', output);
    
    fname = [fun_name, '.m'];
    file_handle = fopen(fname, 'r');


    f_call = fgets(file_handle);
    script_body = f_call;

    tline = fgets(file_handle);

    while(strcmp(tline(1), '%'))
        tline = fgets(file_handle);
    end

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