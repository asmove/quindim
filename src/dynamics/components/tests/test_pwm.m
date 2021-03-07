clear all
close all
clc

% Load parameters
run('./utils/load_pwm_delayed_pred_noised_controller.m');

run('./load_structs.m');
run('run_sim.m');
run('load_plot.m');

