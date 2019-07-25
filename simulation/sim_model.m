function simOut = sim_model(mdlname)
    open_system(mdlname);
    set_param(mdlname, 'SaveOutput', 'on');
    simOut = sim(mdlname, 'AbsTol', '1e-5', 'RelTol', '1e-5');
    close_system(mdlname);
end