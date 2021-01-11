function simOut = simsys(model_name, sys, x0, tf)
    gen_scripts(sys, model_name);

    load_system(model_name);

    simMode = get_param(model_name, 'SimulationMode');
    set_param(model_name, 'SimulationMode', 'normal');

    cs = getActiveConfigSet(model_name);
    mdl_cs = cs.copy;
    set_param(mdl_cs, 'SolverType','Variable-step', ...
                      'SaveState','on','StateSaveName','xoutNew', ...
                      'SaveOutput','on','OutputSaveName','youtNew');

    save_system();

    t0 = tic();
    simOut = sim(model_name, mdl_cs);
    toc(t0);
end