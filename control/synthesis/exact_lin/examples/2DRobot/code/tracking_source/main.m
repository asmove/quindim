% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');
% run('~/github/Robotics4fun/examples/2D_unicycle/code/main.m');
% run('~/github/Robotics4fun/examples/2D_mass/code/main.m');

% Preamble for images and persistent variables cleaning
clear_inner_close_all(pwd);

field_intensity = @(x) x(1)^2 + x(2)^2;

% Initial conditions
x0 = [1, 1, 1, 1]';

xhat_0 = x0(1:2);

source_reference = sys.kin.q(1:2);

% Stability matrices
alpha = 1;

% Parameters
% []
nu = 2;

% []
sigma = 1;

% []
zeta = 1;

% Control 
beta = 1;

% []
lambda = 1;

% [s]
T_cur = 0.1;
T_traj = 0.1;

% Time span
dt = 0.01;
tf = 1;
time = 0:dt:tf;

% Source estimation
sestimation_info.xhat_0 = xhat_0;
sestimation_info.nu = nu;
sestimation_info.zeta = zeta;
sestimation_info.sigma = sigma;
sestimation_info.oracle = field_intensity;
sestimation_info.source_reference = source_reference;
sestimation_info.lambda = lambda;
sestimation_info.T_cur = T_cur;

% Trajectory planning
trajectory_info.T_traj = T_traj;
trajectory_info.dt = dt;

% Point to point control
trajectory_info.gentraj_fun = @(t_i, T, P0, P1) point2point(t_i, T, P0, P1);

% Control law arguments
control_info.eta = eta;
control_info.control_fun = @(t, q_p, refs, qp_symbs, refs_symbs) ...
                             compute_control(t, q_p, refs, ...
                                             qp_symbs, refs_symbs);

% System modelling
u_func = @(t, q_p) control_handler(t, q_p, ...
                                   sestimation_info, ...
                                   trajectory_info, ...
                                   control_info, sys);

sol = validate_model(sys, time, x0, u_func);
time = time';
sol = sol';

% run('~/github/Robotics4fun/control/synthesis/examples/plot_simulation.m')

