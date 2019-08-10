close all;
clear all;
clc;

% Closed chain
mechanism = load_mechanism('num');

% trajectory geenration
L0 = 0.05;
props.delta = 0.33;
props.L0 = L0;
props.A_max = 5;
props.orient = 0;
props.P0 = [L0; L0];
props.P1 = [-L0; L0];
props.P2 = [-L0; -L0];
props.P3 = [L0; -L0];
type = 'rect';

% props.R = 0.05;
% props.omega = 5;
% props.orient = 0;
% type = 'circ';

traj = trajectory(type, props);

% Simulation
sims = calculate_sims(mechanism, traj);

% Plots
plot_qpu(sims);
