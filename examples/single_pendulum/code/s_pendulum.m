% Double Single example
% @Author: Bruno Peixoto

close all
clear all
clc

% The 'real' statement on end is important for inner simplifications
syms tau m b k g Lg real;
syms th thp thpp real;

% Body inertia
I = sym(zeros(3, 3));
I(2, 2) = m*Lg^2;
I(3, 3) = m*Lg^2;

% Position relative to body coordinate system
L = [Lg; 0; 0];

% Bodies transformations
Ts = {T3d(-pi/2, [0; 0; 1], [0; 0; 0]), ...
      T3d(th, [0; 0; 1], [0; 0; 0])};

% Previous body - Inertial, in this case
previous = struct('');

params = [];

% Damper and springs
damper = build_damper(b, [0; 0; 0], [thp; 0; 0]);
spring = build_spring(k, [0; 0; 0], [th; 0; 0]);

pendulum = build_body(m, I, Ts, L, damper, spring, ...
                      th, thp, thpp, previous, params);

% Without spring and damping
sys.syms = [m, b, k, g, Lg];
sys.model_params = [1, 0, 0, 9.8, 1];

sys.gravity = [0; -g; 0];
sys.g = g;

sys.bodies = pendulum;

% Generalized coordinates
sys.q = th;
sys.qp = thp;
sys.qpp = thpp;

% Generalized coordinates
sys.p = thp;
sys.pp = thpp;

% External excitations
sys.Fq = tau;
sys.u = tau;

% Constraint condition
sys.is_constrained = false;

% Sensors
sys.y = th;

% State space representation
sys.states = [th; thp];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Initia conditions [m; m/s]
x0 = [pi/3; 0];

% Time [s]
dt = 0.001;
tf = 5;
t = 0:dt:tf; 

% System modelling
sol = validate_model(sys, t, x0, 0);

x = sol.x;
y = sol.y.';

plot_info.titles = {'$\theta$', '$\dot \theta$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$\theta$ $[rad]$', '$\dot \theta$ $[rad/s]$'};
plot_info.grid_size = [2, 1];

% States and energies plot
hfigs_states = my_plot(x, y, plot_info);
hfig_energies = plot_energies(sys, x, y);

% Energies
saveas(hfig_energies, '../images/energies', 'epsc');

for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../images/states', num2str(i)], 'epsc'); 
end
