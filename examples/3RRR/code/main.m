close all;
clear all;
clc;

% Closed chain
mechanism = load_mechanism('num');

% % Simulation
% props.L0 = 0.05;
% props.A_max = 5;
% props.P0 = [L0; L0];
% props.P1 = [-L0; L0];
% props.P2 = [-L0; -L0];
% props.P3 = [L0; -L0];
% type = 'rect';

props.R = 0.05;
props.omega = 5;
props.orient = 0;
type = 'circ';

traj = trajectory(type, props);
sims = calculate_sims(mechanism, traj);

mechanism.draw_trajectory = @(sim) draw_trajectory(sim, traj);

hfig = figure('units','normalized', 'outerposition', [0 0 1 1]);
address = [pwd, '/../videos/multibody.avi'];
axs = [-0.5, 0.8, -0.8, 0.8];
gen_sys_movie(sims, mechanism, traj.dt, axs, address);

plot_qpu(sims);
