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

% Initial conditions
x0 = [0; 0; 0; 0];

% []
n_V = 1;

% Control weightening matrix
beta = 1;
W = beta*diag([1; 1]);

% [s]
T_cur = 0.1;

% []
perc = 0.95;
eta = -(1/T_cur)*log(1-perc);

% Trajectory tracking
a = 1;
b = 1;
omega = 1;
ref_func = @(t) [a*cos(omega*t); b*sin(omega*t); 
                -a*omega*sin(omega*t); b*omega*cos(omega*t); 
                -a*omega^2*cos(omega*t); -b*omega^2*sin(omega*t)];

% Time span
dt = 0.01;
tf = 1;
time = 0:dt:tf;

% Control law arguments
control_info.W = W;
control_info.poles = [-5, -5];
control_info.Vp_fun = @(V, e) -eta*V^0.5;
control_fun = @(t, q_p) lyap_based_2D(t, q_p, ref_func, control_info, sys);

sol = validate_model(sys, time, x0, control_fun, false);
time = time';
sol = sol';

rob_path = '~/github/Robotics4fun';
cur_path = '/control/synthesis/ljapunov/examples/2D_mass/';

run([rob_path, cur_path, 'plot_2D_tracking.m']);



