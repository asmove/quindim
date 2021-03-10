clear all
close all
clc

% Load parameters
run('./utils/load_plant_and_controller.m');

run('./load_structs.m');
run('run_sim.m');
run('load_plot.m');

