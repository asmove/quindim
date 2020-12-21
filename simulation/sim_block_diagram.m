function simOut = sim_block_diagram(sys, model_name, script_generator, ...
                                    abs_tol, rel_tol)
    
    if(nargin == 3)
        abs_tol = '1e-6';
        rel_tol = '1e-6';
    end
    
    script_generator(sys, model_name);
    
    load_system(model_name);

    simMode = get_param(model_name, 'SimulationMode');
    set_param(model_name, 'SimulationMode', 'normal');

    cs = getActiveConfigSet(model_name);
    mdl_cs = cs.copy;

    save_system();

    t0 = tic();
    simOut = sim(model_name, 'SolverType','Variable-step', ...
                             'AbsTol', abs_tol, 'RelTol', rel_tol, ...
                             'SaveState','on','StateSaveName','xoutNew', ...
                             'SaveOutput','on','OutputSaveName','youtNew');
    toc(t0);

end