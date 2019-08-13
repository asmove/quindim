% Minimal example
% @Author: Bruno Peixoto

clear all
close all
clc

% The 'real' statement on end is important
% for inner simplifications
syms F x xp xpp real;
syms m b k g real;

% Paramater symbolics of the system
sys.descrip.syms = [m, b, k, g];

% Paramater symbolics of the system
sys.descrip.model_params = [1, 0, 9, 9.8];

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Body inertia
I = zeros(3, 3);

% Position relative to body coordinate system
L = zeros(3, 1);

% Bodies definition
T = {T3d(0, [0, 0, 1].', [x; 0; 0])};

damper = build_damper(b, [0; 0; 0], [xp; 0; 0]);
spring = build_spring(k, [0; 0; 0], [x; 0; 0]);
block = build_body(m, I, T, L, damper, spring, ...
                   x, xp, xpp, struct(''), []);

sys.descrip.bodies = block;

% Generalized coordinates
sys.kin.q = x;
sys.kin.qp = xp;
sys.kin.qpp = xpp;

% External excitations
sys.descrip.Fq = F;
sys.descrip.u = F;

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = x;

% State space representation
sys.descrip.states = [x; xp];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Decay time
m_num = sys.descrip.model_params(1);
b_num = sys.descrip.model_params(2);
T = m_num/b_num;

% Time [s]
dt = 0.01;
tf = 5;
t = 0:dt:tf; 

% Initia conditions [m; m/s]
x0 = [0; 1];

% System modelling
sol = validate_model(sys, t, x0, 0);
t = sol.x.';
x = sol.y.';

titles = {'$x$', '$\dot x$'};
xlabels = {'$t$ [s]', '$t$ [s]'};
ylabels = {'$x$ [m]', '$\dot x$ [m/s]'};
grid_size = [2, 1];

% Plot properties
plot_info.titles = titles;
plot_info.xlabels = xlabels;
plot_info.ylabels = ylabels;
plot_info.grid_size = grid_size;

[hfigs_states, hfig_energies] = plot_sysprops(sys, t, x, plot_info);

% Energies
saveas(hfig_energies, '../images/energies.eps', 'epsc');

% States
for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../images/states', num2str(i), '.eps'], 'epsc'); 
end

