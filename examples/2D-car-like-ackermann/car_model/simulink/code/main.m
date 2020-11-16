% Author: Bruno Peixoto
% Date: 08/01/19

% Clear environment
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

% Setup
run('./load_symvars.m');
run('./load_transformations.m');
run('./load_bodies.m');
run('./load_params.m');

% Build
run('./load_consts.m');
run('./load_kin.m');
run('./load_dyn.m');

% Loading and simulation
run('./load_scripts.m');
run('./run_sim.m');

% Visual preparation
run('./run_plot.m');
run('./run_animation.m');
