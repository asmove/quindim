function simOut = simsys(model_name, sys, x0, tf)
    gen_scripts(sys, model_name);
    
    load_system(model_name);
    
    simMode = get_param(model_name, 'SimulationMode');
    set_param(model_name, 'SimulationMode', 'normal');
    
    % 'SolverType','Fixed-step', ...
    % 'FixedStep', '1e-5', ...
    cs = getActiveConfigSet(model_name);
    mdl_cs = cs.copy;
    set_param(mdl_cs, 'StopTime', num2str(tf), ...
              'SolverType', 'Fixed-step', 'FixedStep', '1e-4', ...
              'SaveState','on','StateSaveName','xoutNew', ...
              'SaveOutput','on','OutputSaveName','youtNew');

    save_system();
    
    t0 = tic();
    simOut = sim(model_name, mdl_cs);
    toc(t0);
    
    % Supress values close to zero
    THRES = 1e-3;
    fields = simOut.who;
    
    idx_t = 1;
    idx_x = 2;
    for idx = 1:length(fields)
        if(strcmp(fields{idx}, 'tout'))
            idx_t = idx;
        end 
        
        if(strcmp(fields{idx}, 'xoutNew'))
            idx_x = idx;
        end 
    end
    
    n = length(fields);
    
    fields(idx_t) = [];
    
    if(idx_t < idx_x)
        fields(idx_x-1) = [];
    else
        fields(idx_x-1) = [];
    end
    
    fields_struct = {};
    zero_struct = {};
    for i = 1:length(fields)
        zero_struct{end+1} = 0;
        fields_struct{end+1} = fields{i};
    end
    
    sim_struct = cell2struct(zero_struct, fields_struct, 2);
    
    for i = 1:length(fields)
        field = fields{i};
        
        attr = simOut.(field);
        
        matrix = attr.signals.values;
        
        %matrix_bool = abs(matrix) > THRES;
        idxs = find(abs(matrix) < THRES);
        matrix(idxs) = 0;
        
        aux.time = simOut.time;
        aux.signals.values = matrix;
        
        sim_struct.(field) = aux;
    end
    
    sim_struct.tout = simOut.tout;
    simOut = sim_struct;
end