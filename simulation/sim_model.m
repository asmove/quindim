function simOut = sim_model(mdlname, tf)
    open_system(mdlname);
    set_param(mdlname, 'SaveOutput', 'on');
    simOut = sim(mdlname, 'AbsTol', '1e-5', ...
                          'RelTol', '1e-5', ...
                          'StopTime', num2str(tf));
    close_system(mdlname);
end