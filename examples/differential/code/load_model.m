if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

run('load_symvar.m');
run('load_components.m');
run('load_bodies.m');
run('load_params.m');

% Load car model
run('./load_kin.m');

sys = dynamic_model(sys);
