% Minimal example
% @Author: Bruno Peixoto

clear all
close all
clc

% The 'real' statement on end is important
% for inner simplifications
syms F q i ip real;
syms R L C g real;
syms Vcc u real;

% Paramater symbolics of the system
sys.descrip.syms = [R, L, C, Vcc];

% Paramater symbolics of the system
sys.descrip.model_params = [25e-6, 19e-3, 0.5, 140];

% Gravity utilities
sys.descrip.gravity = [0; 0; 0];
sys.descrip.g = g;

% Body inertia
I = diag([L, L, L]);

% Position relative to body coordinate system
L0 = zeros(3, 1);

% Bodies definition
T = {T3d(0, [0, 0, 1].', [q; 0; 0])};

damper = build_damper(R, [0; 0; 0], [i; 0; 0]);
spring = build_spring(1/C, [0; 0; 0], [q; 0; 0]);
block = build_body(L, I, T, L0, damper, spring, ...
                   q, i, ip, struct(''), []);

sys.descrip.bodies = block;

% Generalized coordinates
sys.kin.q = q;
sys.kin.qp = i;
sys.kin.qpp = ip;

% External excitations
sys.descrip.Fq = Vcc*u;
sys.descrip.u = u;

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = i;

% State space representation
sys.descrip.states = [q; i];

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

titles = {'$q$', '$i$'};
xlabels = {'$t$ [s]', '$t$ [s]'};
ylabels = {'$q$ [C]', '$i$ [A]'};
grid_size = [2, 1];

% Plot properties
plot_info.titles = titles;
plot_info.xlabels = xlabels;
plot_info.ylabels = ylabels;
plot_info.grid_size = grid_size;

[hfigs_states, hfig_energies] = plot_sysprops(sys, t, x, plot_info);

% Energies
saveas(hfig_energies, '../imgs/energies.eps', 'epsc');

% States
for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../imgs/states', num2str(i), '.eps'], 'epsc'); 
end

