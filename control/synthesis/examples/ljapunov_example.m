clear all
close all
clc

run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');
% run('~/github/Robotics4fun/examples/2D_unicycle/code/main.m');

close all
delete(findall(0,'type','figure','tag','TMWWaitbar'));

field_intensity = @(x) x(1)^2 + x(2)^2;

% Initial conditions
% x0 = [1, 1, 1, 1]';
x0 = [1, 1, 0, 0, 1, 1]';
xhat_0 = x0(1:2);

source_reference = sys.kin.q(1:2);

% Stability matrices
alpha = 1;
P = alpha*eye(length(source_reference));

% Parameters
% []
nu = 10;

% []
sigma = 0.5;

% []
zeta = 1;

% Control polynomial
degree_G = 3;

% Control 
beta = 1;
W = beta*diag([1; 1]);

% []
lambda = 1;

% [s]
T = 0.1;

% []
perc = 0.65;
eta = -(1/T)*log(1-perc);

% Time span
time = 0:0.001:0.1;

% System modelling
u_func = @(t, q_p) control_handler(t, q_p, source_reference, xhat_0, ...
                                   nu, sigma, lambda, zeta, eta, ...
                                   field_intensity, T, P, degree_G, W, sys);

sol = validate_model(sys, t, x0, u_func);
time = time';
sol = sol';

% run('~/github/Robotics4fun/control/synthesis/examples/plot_simulation.m')

