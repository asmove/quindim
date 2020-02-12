clear all
close all
clc

run('~/github/Robotics4fun/examples/2D_mass/code/main.m');

% Preamble for images and persistent variables cleaning
close all
delete(findall(0,'type','figure','tag','TMWWaitbar'));
for filepath = strsplit(ls, ':')
    clear filepath;
end

field_intensity = @(x) x(1)^2 + x(2)^2;

% Initial conditions
x0 = [1, 1, 1, 1]';
xhat_0 = x0(1:2);

source_reference = sys.kin.q(1:2);

% Stability matrices
alpha = 1;
P = alpha*eye(length(sys.kin.q));

% Parameters
% []
nu = 20;

% []
sigma = 1;

% []
sigma_traj = 1;

% []
zeta = 1;

% Control 
beta = 1;
W = beta*diag([1; 1]);

% []
lambda = 1;

% []
poles = [-5, -5];

% []
degree_interp = 3;

% []
n_V = 1;

% [s]
T_cur = 0.1;
T_traj = 0.1;

% []
perc = 0.95;
eta = -(1/T_cur)*log(1-perc);

% Time span
dt = 0.01;
tf = pi;
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
traj_type = 'polynomial';
trajectory_info.T_traj = T_traj;
trajectory_info.sigma_traj = sigma_traj;
trajectory_info.dt = dt;
trajectory_info.degree_interp = degree_interp;
trajectory_info.gentraj_fun = @(t, x_begin, x_end) ...
        gen_trajectory_2Dmass(t, dt, T_traj, x_begin, x_end, ...
                              source_reference, degree_interp, ...
                              sys, true, traj_type);

% Control law arguments
control_info.Vp_fun = @(V) -eta*V^n_V;
control_info.alpha_q = 100;
control_info.alpha_p = 1;
control_info.control_fun = @(t, q_p, ...
                             xhat_traj, xphat_traj, xpphat_traj, ...
                             phat_traj, pphat_traj) ...
                             lyap_based(t, q_p, xhat_traj, xphat_traj, ...
                                        xpphat_traj, phat_traj, ...
                                        pphat_traj, sys, ...
                                        control_info);

% System modelling
u_func = @(t, q_p) control_handler(t, q_p, sestimation_info, ...
                                   trajectory_info, ...
                                   control_info, sys);

sol = validate_model(sys, time, x0, u_func);
time = time';
sol = sol';

run('~/github/Robotics4fun/control/synthesis/ljapunov/examples/2D_mass/plot_simulation_2Dmass.m');
