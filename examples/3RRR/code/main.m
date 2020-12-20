close all;
clear all;
clc;

t0 = tic;

run('./load_model.m');

run('./run_sim.m');

plot_qpu(sims);

