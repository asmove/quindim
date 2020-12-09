if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

run('load_symvars.m');
run('load_transformations.m');
run('load_bodies.m');
run('load_params.m');

% Load kinematic model
run('./run_kin.m');

% Load dynamic model
run('./run_dyn.m');