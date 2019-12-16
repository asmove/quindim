clear all
close all
clc

run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');

field_intensity = @(x) x(1)^2 + x(2)^2;

% Initial conditions
x0 = [1, 1, 3*pi/4, 0, 1, 1]';
xhat_0 = x0(1:2)';

x = sys.kin.q(1:2);

% Stability matrices
Q = eye(length(x));
P = eye(length(x));

% Parameters
% []
nu = 1;

% []
sigma = 1;

% []
zeta= 0;

% [s]
T = 0.1;

% []
lambda = 1;

% Time span
t = 0:0.01:0.5;

% System modelling
curious_fun = @(t, xhat, m) curiosity_fun(t, xhat, m, oracle, ...
                                          nu, sigma, zeta);

oracle = @(t, curr_pos) source_estimation(t, curr_pos, ...
                                          xhat_0, nu, sigma, ...
                                          lambda, field_intensity, ...
                                          T, x, sys);
                                      
u_func = @(t, q_p) ljapunov_based(t, q_p, oracle(t, q_p), Q, P, x, sys);
sol = validate_model(sys, t, x0, u_func);

x = t';
y = sol';

% Generalized coordinates
plot_info_q.titles = repeat_str('', 4);
plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$'};
plot_info_q.grid_size = [2, 2];

hfigs_states = my_plot(x, y(:, 1:4), plot_info_q);

plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = {'$t$ [s]', '$t$ [s]'};
plot_info_p.ylabels = {'$\omega_{\theta}$', '$\omega_{\phi}$'};
plot_info_p.grid_size = [2, 1];

% States plot
hfigs_speeds = my_plot(x, y(:, 5:6), plot_info_p);

