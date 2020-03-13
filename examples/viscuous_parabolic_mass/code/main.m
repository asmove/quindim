% Minimal example
% @Author: Bruno Peixoto
clear all
close all
clc

% The 'real' statement on end is important
% for inner simplifications
syms F;
syms x_pos xp xpp real;
syms y_pos yp ypp real;
syms m b g real;

% Paramater symbolics of the system
sys.descrip.syms = [m, b, g];

% Paramater symbolics of the system
sys.descrip.model_params = [1, 1, 9.8];

% Gravity utilities
sys.descrip.gravity = [0; -g; 0];
sys.descrip.g = g;

% Fields for plot
sys.descrip.latex_origs = {{'xpp'}, ...
                           {'\mathrm{xp}'}, ...
                           {'x_pos'}, ...
                           {'ypp'}, ...
                           {'\mathrm{yp}'}, ...
                           {'y_pos'}};

sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', 'x', ...
                          '\ddot{y}', '\dot{y}', 'y'};

% Body inertia
I = zeros(3, 3);

% Position relative to body coordinate system
L = [x_pos; x_pos^2; 0];

% Bodies definition
T = {T3d(0, [0, 0, 1].', [0; 0; 0])};

damper = build_damper(b, [0; 0; 0], [xp; yp; 0]);
block = build_body(m, I, T, L, {damper}, {}, ...
                   [x_pos; y_pos], [xp; yp], [xpp; ypp], struct(''), []);

sys.descrip.bodies = {block};

% Generalized coordinates
sys.kin.q = [x_pos; y_pos];
sys.kin.qp = [xp; yp];
sys.kin.qpp = [xpp; ypp];

% External excitations
sys.descrip.Fq = [0; 0];
sys.descrip.u = [];

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = [x_pos; y_pos];

% State space representation
sys.descrip.states = [x_pos; y_pos; xp; yp];

% Kinematic and dynamic model
sys.descrip.is_constrained = true;
sys.descrip.hol_constraints = {y_pos - x_pos^2};

sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Initia conditions [m; m/s]
x0 = [0.1; 0.01; 0];

% Final time
tf = 1;
dt = 0.01;
tspan = 0:dt:tf;

u_func = @(t, x) [0; 0];

% System modelling
sol = validate_model(sys, tspan, x0, u_func, false);
x = sol';
tspan = tspan';

% Plot properties
titles = {'$x$', '$y$', '$\dot x$'};
xlabels = {'', '', '$t$ [s]'};
ylabels = {'$x$  [m]', '$y$  [m]', '$\dot x$ [m/s]'};
grid_size = [3, 1];

plot_info.titles = titles;
plot_info.xlabels = xlabels;
plot_info.ylabels = ylabels;
plot_info.grid_size = grid_size;

[hfigs_states, hfig_energies, hfig_consts] = plot_sysprops(sys, tspan, ...
                                                           x, plot_info);

% Energies
saveas(hfig_energies, '../imgs/energies.eps', 'epsc');

% States
for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../imgs/states', num2str(i), '.eps'], 'epsc'); 
end

% Energies
saveas(hfig_energies, '../imgs/constraints.eps', 'epsc');

