function simOut = sim_block_diagram(sys, model_name, ...
                  script_generator, abs_tol, rel_tol)
    script_generator(sys, model_name);

    load_system(model_name);

    simMode = get_param(model_name, 'SimulationMode');
    set_param(model_name, 'SimulationMode', 'normal');

    cs = getActiveConfigSet(model_name);
    mdl_cs = cs.copy;
    set_param(mdl_cs, 'SolverType','Variable-step', ...
                      'AbsTol', abs_tol, 'RelTol', rel_tol, ...
                      'SaveState','on','StateSaveName','xoutNew', ...
                      'SaveOutput','on','OutputSaveName','youtNew');

    save_system();

    t0 = tic();
    simOut = sim(model_name, mdl_cs);
    toc(t0);

end