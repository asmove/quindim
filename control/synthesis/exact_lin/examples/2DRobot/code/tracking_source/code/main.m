% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');
% run('~/github/Robotics4fun/examples/2D_mass/code/main.m');
% run('~/github/Robotics4fun/examples/2D_unicycle/code/main.m');

for filename = ls(pwd)
    if(filename ~= 'sys')
        continue
    else
        clear filename;
    end 
end

% Initial conditions
x0 = [1; 1; 0; 1; 1; 1];

% Source estimation parameters
sestimation_info.xhat_0 = x0(1:2);
sestimation_info.nu = 2;
sestimation_info.zeta = 1;
sestimation_info.sigma = 0.5;
sestimation_info.oracle = @(x) x(1)^2 + x(2)^2;
sestimation_info.source_reference = sys.kin.q(1:2);
sestimation_info.lambda = 1;
sestimation_info.T_cur = 0.25;

% Trajectory planning
trajectory_info.T_traj = 0.5;
trajectory_info.dt = 0.05;

T_traj = trajectory_info.T_traj;
T_cur = sestimation_info.T_cur;

alpha_control = 0.5;
T_control = alpha_control*T_cur;

poles_ = {[-1/T_control, -1/T_control], ...
          [-1/T_control, -1/T_control]};

% Trajectory generation
n_diff = 3;
alphaA = 0.5;
alphaB = 0.5;
trajectory_info.gentraj_fun = @(t, P0, P1, theta0) ...
                              bezier_path(t, T_traj, P0, P1, theta0, ...
                                          alphaA, alphaB, n_diff);

% Control law arguments
control_info.control_fun = @(t, q_p, refs, qp_symbs, refs_symbs) ...
                             compute_control(t, q_p, refs, qp_symbs, ...
                                            refs_symbs, sys, poles_);

% System modelling
u_func = @(t, q_p) control_handler(t, q_p, sestimation_info, ...
                                   trajectory_info, control_info, sys);

tf = 1;
dt = trajectory_info.dt;
time = 0:dt:tf;

sol = validate_model(sys, time, x0, u_func, true);
time = time';
sol = sol';

run('plot_simulation.m')

