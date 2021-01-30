function save_simmodel(mdlname, path)
    open_system(mdlname);
    print(['-s', mdlname], '-dpdf', path);
    close_system;
end