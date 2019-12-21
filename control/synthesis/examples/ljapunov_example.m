clear all
close all
clc

run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');

close all
delete(findall(0,'type','figure','tag','TMWWaitbar'));

field_intensity = @(x) x(1)^2 + x(2)^2;

% Initial conditions
x0 = [1, 1, pi/4, 0, 1, 1]';
xhat_0 = x0(1:2)';

source_reference = sys.kin.q(1:2);

% Stability matrices
Q = eye(length(source_reference));
P = eye(length(source_reference));

% Parameters

% []
nu = 5;

% []
sigma = 1;

% []
zeta = 1;

% []
lambda = 1;

% [s]
T = 0.5;

% []
perc = 0.99;
eta = -(1/T)*log(1-perc);

% Time span
t = 0:0.005:5;

% System modelling
u_func = @(t, q_p) control_handler(t, q_p, source_reference, xhat_0, ...
                                   nu, sigma, lambda, zeta, eta, ...
                                   field_intensity, T, Q, P, sys);

sol = validate_model(sys, t, x0, u_func);

run([pwd, '/plot_simulation.m'])

