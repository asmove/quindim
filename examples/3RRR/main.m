close all;
clear all;
clc;

t0 = tic;

% Closed chain
mechanism = load_mechanism('num');

% Implicit attributes for 
mechanism.eqdyn = orsino_eqdyn(mechanism); 
toc(t0)

% Calculate value for q_circ
[mechanism.q_circ_fun, mechanism.is_ws_fun] = load_q_circ(mechanism);

% Simulation
traj = trajectory();

sims = calculate_sims(mechanism, trajectory);

% hfig = figure('units','normalized', 'outerposition', [0 0 1 1]);
% address = [pwd, '/../videos/multibody.avi'];
% axs = [-0.5, 0.8, -0.8, 0.8];
% simulate(sims, mechanism, traj.dt, axs, address);

plot_qpu(sims);
