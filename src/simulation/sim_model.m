function simOut = sim_model(mdlname, x0, tf)
    open_system(mdlname);
    set_param(mdlname, 'SaveOutput', 'on');
    simOut = sim(mdlname, 'AbsTol', '1e-6', ...
                          'RelTol', '1e-6', ...
                          'StopTime', num2str(tf));
    close_system(mdlname);
end