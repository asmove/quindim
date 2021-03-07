function simOut = sim_block_diagram(model_name, x0, options)
    
    if(nargin == 2)
        options.abs_tol = '1e-6';
        options.rel_tol = '1e-6';
    end
    
    load_system(model_name);

    simMode = get_param(model_name, 'SimulationMode');
    set_param(model_name, 'SimulationMode', 'normal');

    cs = getActiveConfigSet(model_name);
    mdl_cs = cs.copy;

    save_system();
    
    abs_tol = options.abs_tol;
    rel_tol = options.rel_tol;
    
    % 'SolverType','Fixedstep', AbsTol', abs_tol, 'RelTol', rel_tol, ...
    
    t0 = tic();
    simOut = sim(model_name, 'SaveState','on','StateSaveName','xoutNew', ...
                             'SaveOutput','on','OutputSaveName','youtNew');
    toc(t0);
    close_system(model_name);
    
    % Supress values close to zero
    THRES = 1e-5;
    
    fields = fieldnames(simOut);
    
    for field = fields
        if(isfield(simOut, 'signal'))
            vec = simOut(field).signals.values;
        
            vec_supressed = suppress_zero_fluctuation(vec, THRES);
            simOut(field).signals.values = vec_supressed;
        end
    end
    
end