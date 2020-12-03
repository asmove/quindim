if(~exist('CLEAR_ALL'))
    clear all;
else
    if(CLEAR_ALL)
        clear all
    end
end

SIM_SYS = true;

close all

run('./load_symvars.m');
run('./load_transformations.m');
run('./load_bodies.m');
run('./load_params.m');
run('./load_kin.m');
run('./load_dyn.m');
