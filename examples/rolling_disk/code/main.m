% Author: Bruno Peixoto
% Date: 08/01/19

clear all
close all
clc

syms g u;

% Body 1
syms m R real;
syms x y th phi real;
syms xp yp thp phip real;
syms xpp ypp thpp phipp real;

Is = sym('I', [3, 1], 'real');
I = diag(Is);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x; y; R]);
T2 = T3d(th, [0; 0; 1], [0; 0; 0]);
T3 = T3d(phi, [0; -1; 0], [0; 0; 0]);
Ts = {T1, T2, T3};

% CG position relative to body coordinate system
L = [0; 0; 0];

% Generalized coordinates
sys.kin.q = [x; y; th; phi];
sys.kin.qp = [xp; yp; thp; phip];
sys.kin.qpp = [xpp; ypp; thpp; phipp];

% Previous body
previous = struct('');

wheel = build_body(m, I, Ts, L, {}, {}, ...
                   sys.kin.q, sys.kin.qp, sys.kin.qpp, ...
                   previous, []);
sys.descrip.bodies = wheel;

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Paramater symbolics of the system
sys.descrip.syms = [m, R, Is.', g];

% Penny data
m_num = 2.5e-3;
R_num = 9.75e-3;
sys.descrip.model_params = [2.5e-3, 9.75e-3, ...
                    m_num*R_num^2/2, ...
                    m_num*R_num^2/4, ...
                    m_num*R_num^2/2, ...
                    9.8];

% External excitations
sys.descrip.Fq = [0; 0; 0; 0];
sys.descrip.u = u;

% State space representation
sys.descrip.states = [x; y; th; phi];

% Constraint condition
sys.descrip.is_constrained = true;

% Nonholonomic constraints
sys.descrip.unhol_constraints = xp*sin(th) - yp*cos(th);

% Kinematic and dynamic model
sys = kinematic_model(sys);

% Simplification due ill-formed column
% It may appear depending of the system
sys.kin.C(:, 1) = sin(th)*sys.kin.C(:, 1);

sys = dynamic_model(sys);

% Time [s]
dt = 0.1;
tf = 5;
t = 0:dt:tf; 

% Initial conditions [m; m/s]
% x = 1, y = 1, v = 1
x0 = [1, 1, pi/4, 0, 1, 1, 1]';

% System modelling
sol = validate_model(sys, t, x0, 0);

x = sol.x.';
y = sol.y.';

% Generalized coordinates
plot_info_q.titles = {'$x$', '$y$', '$\theta$', '$\phi$'};
plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$'};
plot_info_q.grid_size = [2, 2];

hfigs_states = my_plot(x, y(:, 1:4), plot_info_q);

plot_info_p.titles = {'$v$', '$\omega_{\theta}$', '$\omega_{\phi}$'};
plot_info_p.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info_p.ylabels = {'$v$', '$\omega_{\theta}$', '$\omega_{\phi}$'};
plot_info_p.grid_size = [3, 1];

% States plot
hfigs_states = my_plot(x, y(:, 5:7), plot_info_p);

% Energies plot
hfig_energies = plot_energies(sys, x, y);
hfig_consts = plot_constraints(sys, x, y);

% Images
saveas(hfig_energies, '../images/energies', 'epsc');
saveas(hfig_consts, '../images/constraints', 'epsc');
saveas(hfigs_states(1), ['../images/states', num2str(1)], 'epsc'); 
