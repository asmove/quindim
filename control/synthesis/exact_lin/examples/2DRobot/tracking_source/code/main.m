clear all
close all
clc

% run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');
% run('~/github/Robotics4fun/examples/2D_mass/code/main.m');
run('~/github/Robotics4fun/examples/2D_unicycle/code/main.m');

clearvars -except sys

clear_inner_close_all(pwd);

% Initial conditions
x0 = [1; 1; 0; 1; 1; 1];

T_cur = 0.2;
T_traj = 5;

% Source estimation parameters
sestimation_info.xhat_0 = x0(1:2);
sestimation_info.nu = 2;
sestimation_info.zeta = 1;
sestimation_info.sigma = 0.5;
sestimation_info.oracle = @(x) x(1)^2 + x(2)^2;
sestimation_info.source_reference = sys.kin.q(1:2);
sestimation_info.lambda = 1;
sestimation_info.T_cur = T_cur;

% Trajectory planning
trajectory_info.T_traj = T_traj;
trajectory_info.dt = 0.001;

prec = 0.1;
n_T = 2;
T = T_cur/n_T;
lambda_ = -(1/T)*log(prec);

poles_ = {-lambda_*ones(3, 1), ...
          -lambda_*ones(3, 1)};

% Trajectory generation
traj_type = 'line';
T = T_cur;

n_diff = 3;
alphaA = 0.5;
alphaB = 0.5;
trajectory_info.gentraj_fun = @(t, P0, P1, theta0) traj_t(t, T, P0, P1, ...
                                                          theta0, traj_type, sys);

% n_Ts = 5;
% options.Ts = n_Ts*trajectory_info.dt;
% options.sigma_noise = 0.2;
% options = struct('');

n_f = 2;
frequency = 2*pi/(n_f*T_cur);
amplitude = 1;

options = struct('frequency', frequency, ...
                 'amplitude', amplitude);

% Control law arguments
control_info.control_fun = @(t, q_p, refs, qp_symbs, refs_symbs) ...
                             compute_control(t, q_p, refs, qp_symbs, ...
                                             refs_symbs, sys, poles_, options);

% System modelling
u_func = @(t, q_p) control_handler(t, q_p, sestimation_info, ...
                                   trajectory_info, control_info, sys);


n_tf = 20;
tf = (n_tf + 0.1)*T_cur;
dt = trajectory_info.dt;
time = 0:dt:tf;

sol = validate_model(sys, time, x0, u_func, true);
time = time';
sol = sol';

run('plot_simulation.m')

