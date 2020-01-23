clear all
close all
clc

run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');
% run('~/github/Robotics4fun/examples/2D_unicycle/code/main.m');

close all
delete(findall(0,'type','figure','tag','TMWWaitbar'));


for filepath = strsplit(ls, ':')
    clear filepath;
end

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
sigma = 1;

% []
zeta = 1;

% Control 
beta = 1;
W = beta*diag([1; 1]);

% []
lambda = 1;

% []
degree_interp = 3;

% [s]
T_cur = 0.05;
T_traj = 1;

% []
perc = 0.99;
eta = -(1/T_cur)*log(1-perc);

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
trajectory_info.degree_interp = T_traj;
trajectory_info.gentraj_fun = ...
    @(t, x_begin, x_end, T) generate_trajectory(t, dt, T, x_begin, x_end,... 
                                                source_reference, ...
                                                degree_interp, sys, ...
                                                true);

% Control law arguments
control_info.P = P;
control_info.W = W;
control_info.eta = eta;
control_info.control_fun = @(t, q_p) lyap_based(t, q_p, sys);

% Time span
dt = 0.01;
tf = 1;
time = 0:dt:tf;

% System modelling
u_func = @(t, q_p) control_handler(t, q_p, ...
                                   sestimation_info, ...
                                   trajectory_info, ...
                                   control_info, sys);

sol = validate_model(sys, time, x0, u_func);
time = time';
sol = sol';

run('~/github/Robotics4fun/control/synthesis/examples/plot_simulation.m')

