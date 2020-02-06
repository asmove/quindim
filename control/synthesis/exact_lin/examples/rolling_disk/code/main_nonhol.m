clear all
close all
clc

run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');
run('~/github/Robotics4fun/examples/rolling_disk/code/controller_nonhol.m');

% Ellipsoid trajectory
a = 1;
b = 1;
omega = 1;

% pos, vel, accel, jerk
ref_func = @(t) [a*cos(omega*t); b*sin(omega*t); ...
                 -a*omega*sin(omega*t); b*omega*cos(omega*t); ...
                 -a*omega^2*cos(omega*t); -b*omega^2*sin(omega*t); ...
                 a*omega^3*sin(omega*t); -b*omega^3*cos(omega*t)];

x_ref_sym = [x_sym; ref_syms];

input_func = @(t, q_p) vpa(subs(w, x_ref_sym, [q_p; ref_func(t)]));
sim_fun = @(t, q_p) plant_fun(t, q_p, sys, input_func, V);

symbs = [w_syms; x_sym; symbs.'];

x0 = [0; 0; 0; 0; 0; 1; 0];
tf = pi;
dt = 0.01;

% Time vector
t = 0:dt:tf;

% Mass matrix
sol = my_ode45(sim_fun, t, x0);
sol = sol';

run('~/github/Robotics4fun/control/synthesis/exact_lin/examples/plot_nonhol.m');

