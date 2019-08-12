% Author: Senzu
% Date: 08/01/19

clear all
close all
clc

% Body 1
syms m1 b1 k1 real;
syms x1 x1p x1pp real;

I1 = sym(zeros(3, 3));

T1s = {T3d(0, [0; 0; 1], [x1; 0; 0])};
is_friction_linear1 = true;

% Previous body - Inertial, in this case
% CG position relative to body coordinate system
L1 = [0; 0; 0];

% Body 2
syms x2 x2p x2pp real;
syms m2 b2 k2 real;

% CG position relative to body coordinate system
L2 = [0; 0; 0];

I2 = sym(zeros(3, 3));
T2s = {T3d(0, [0; 0; 1], [x2; 0; 0])};
is_friction_linear2 = true;

% Bodies inertia
damper1 = build_damper(b1, [0; 0; 0], [x1p; 0; 0]);
spring1 = build_spring(k1, [0; 0; 0], [x1; 0; 0]);

previous1 = struct('');
body1 = build_body(m1, I1, T1s, L1, damper1, spring1, ...
                   x1, x1p, x1pp, previous1, []);

% Body 2
previous2 = body1;

damper2 = build_damper(b2, [x1p; 0; 0], [x2p; 0; 0]);
spring2 = build_spring(k2, [x1; 0; 0], [x2; 0; 0]);

body2 = build_body(m2, I2, T2s, L1, damper2, spring2,...
                   x2, x2p, x2pp, previous2, []);

syms g u;

sys.syms = [m1, b1, k1, m2, b2, k2, g];

% Paramater symbolics of the system
sys.model_params = [1, 0, 1, 1, 0, 1, 9.8];

sys.bodies = [body1, body2];

% Gravity utilities
sys.gravity = [0; 0; -g];
sys.g = g;

% Generalized coordinates
sys.q = [x1; x2];
sys.qp = [x1p; x2p];
sys.qpp = [x1pp; x2pp];

% Quasi-velocities
sys.p = [x1p; x2p];
sys.pp = [x1pp; x2pp];

% External excitations
sys.Fq = [0; u];
sys.u = u;

% Sensors
sys.y = [x1; x2];

% State space representation
sys.states = [x1; x2; x1p; x2p];

% Constraint condition
sys.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Decay time
m_num = sys.model_params(1);
b_num = sys.model_params(2);
T = m_num/b_num;

% Initia conditions [m; m/s]
x0 = [0; 1; 0; 1];

% Time [s]
dt = 0.001;
tf = 20;
t = 0:dt:tf; 

% System modelling
sol = validate_model(sys, t, x0, 0);

x = sol.x.';
y = sol.y.';

plot_info.titles = {'$x_1$', '$\dot x_1$', '$x_2$', '$\dot x_2$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$x_1$ $[m]$', '$\dot x_1$ $[m/s]$', '$x_2$ $[m]$', '$\dot x_2$ $[m/s]$'};
plot_info.grid_size = [2, 2];

% States and energies plot
hfigs_states = my_plot(x, y, plot_info);
hfig_energies = plot_energies(sys, x, y);

% Energies
saveas(hfig_energies, '../images/energies', 'epsc');

for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../images/states', num2str(i)], 'epsc'); 
end