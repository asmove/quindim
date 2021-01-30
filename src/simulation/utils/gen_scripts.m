function [] = gen_scripts(sys, model_name)

    q = sys.kin.q;
    qp = sys.kin.qp;
    p = sys.kin.p{end};
    u = sys.descrip.u;
    vars_const = terop(~isempty(u), {[q; p], u}, {[q; p]});
    
    vars = {{[q; p]}, {[q; p]}, {[q; p]}, vars_const};
    
    if(isempty(sys.descrip.u))
        Uu = zeros(length(sys.kin.q), 1);
    else
        Uu = sys.dyn.U*sys.descrip.u;
    end
    
    Q = Uu - sys.dyn.nu - sys.dyn.g - sys.dyn.f_b - sys.dyn.f_k;
    
    Z = sys.dyn.Z;
    u = sys.descrip.u;
    h = sys.dyn.h;
    C = sys.kin.C;
    A = sys.kin.A;
    dA = dmatdt(A, q, C*p);
    dC = dmatdt(C, q, C*p);
    M = sys.dyn.M;
    
    if(isempty(Z*u))
        H_pp = - h;
    else
        H_pp = Z*u - h;
    end
    
    expr_syms = {C*p; C; M; H_pp};
    
    for j = 1:length(expr_syms)
        
        expr_sym = expr_syms(j);
        expr_sym = expr_sym{1};
        
        if(isempty(expr_sym))
            expr_syms{j} = zeros(1);
        end
    end
    
    Outputs = {{'qp'}, {'C'}, {'M_matrix'}, {'fs'}};
    
    paths = {[model_name, '/Plant/Dynamic system/Auxiliary_matrices/C_p'], ...
             [model_name, '/Plant/Dynamic system/Auxiliary_matrices/C_matrix'], ...
             [model_name, '/Plant/Dynamic system/Mass_block/mass_tensor'], ...
             [model_name, '/Plant/Dynamic system/Efforts/Constrained_efforts']};
    
    fun_names = {'KinematicVector', 'ConstraintMatrix', 'Mass_matrix', 'ConstrainedEffort'};

    symbs = sys.descrip.syms;
    vals = sys.descrip.model_params;

    % Read buffer
    nchar = 100000;

    open_system(model_name);

    sf = Simulink.Root;

    for i = 1:length(paths)
        block = sf.find('Path', paths{i}, '-isa','Stateflow.EMChart');
        
        expr_sym = expr_syms{i};
        output = Outputs{i};
        vars_i = vars{i};
        fun_name = fun_names{i};
        
        expr_sym = subs(expr_sym, symbs, vals);
        
        matlabFunction(expr_sym, 'File', fun_name, 'Vars', vars_i, 'Outputs', output);

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
    
    save_system(model_name);
    close_system(model_name);
end
    
