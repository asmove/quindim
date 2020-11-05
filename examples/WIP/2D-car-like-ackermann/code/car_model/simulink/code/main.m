% Author: Bruno Peixoto
% Date: 08/01/19
if(~exist('CLEAR_ALL'))
    clear all;
else
    if(CLEAR_ALL)
        clear all
    end
end

SIM_SYS = true;

close all
clc

run('./load_symvars.m');
run('./load_transformations.m');
run('./load_bodies.m');
run('./load_params.m');
run('./load_kindyn.m');
run('./run_sim.m');
%run('./run_plot.m');
run('./run_animation.m');
