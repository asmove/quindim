clear all
close all
clc

% Load system
run('~/github/Robotics4fun/examples/2D_unicycle/code/main.m');

clearvars -except sys
clear_inner_close_all(pwd);

% Initial conditions
x0 = [2; 2; 0; 1; 1; 1];

% Load parameters
T_cur = 1;
T_traj = 1;

lambda = 1;
nu = 10;
zeta = 5;
sigma = 0.2;
xhat_0 = x0(1:2);

% Source estimation parameters
sestimation_info.xhat_0 = x0(1:2);
sestimation_info.nu = nu;
sestimation_info.zeta = zeta;
sestimation_info.sigma = sigma;
sestimation_info.oracle = @(x) x(1)^2 + x(2)^2;
sestimation_info.source_reference = sys.kin.q(1:2);
sestimation_info.lambda = lambda;
sestimation_info.T_cur = T_cur;

% Trajectory planning
trajectory_info.T_traj = T_traj;
trajectory_info.dt = 0.001;

SAT_CONTROL = 10;
SEED_SPAN = 100;

traj_type = 1;

% Load controller parameters
perc = 0.1;
mu = -1/T_cur*log(perc);
poles_ = {-mu*ones(3, 1), ...
          -mu*ones(3, 1)};

% Load
tf = 20;
dt = trajectory_info.dt;
time = 0:dt:tf;

model_name = 'bary_source_seeking';
simOut = sim(model_name);

run('plot_simulink_results.m');

