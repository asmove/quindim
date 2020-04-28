% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/2D_unicycle/code/main.m');

syms t_ T;

P0 = [0; -3];
P1 = [0; 3];
theta0 = 0;
thetaf = pi/2;

% Time vector
tf = 0.5;
dt = 0.01;
t = 0:dt:tf;

T_traj = tf;

% % Flower trajectory
% k = 3;
% xy_t = [cos(k*t_)*cos(t_); cos(k*t_)*sin(t_)];

% Line trajectory
traj_type = 'line';
xy_t = P0 + t_*(P1 - P0);

% % Bezier curve
% alphaA = 0.3;
% alphaB = 0.3;
% xy_t = vpa(expand(bezier_path(t_, T_traj, P0, P1, theta0, alphaA, alphaB)));

% % Exponential and polynomial curves
% % traj_type = 'exp';
% traj_type = 'polynomial';
% 
% point0.t = 0;
% point0.coords = [P0; theta0];
% point1.t = T_traj;
% point1.coords = [P1; thetaf];
% 
% points_ = [point0; point1];
% 
% % Coefficients generation
% [params_syms, ...
%  params_sols, ...
%  params_model] = gentrajmodel_2Drobot(sys, ...
%                  traj_type, T_traj, points_);
% 
% params_sols = double(params_sols);
% 
% xy_t = subs(params_model, ...
%             [params_syms; T; sym('t')], ...
%             [params_sols; T_traj; t_]);

dxy_t = diff(xy_t, t_);
d2xy_t = diff(dxy_t, t_);
d3xy_t = diff(d2xy_t, t_);

ref_func = @(t) subs([xy_t; dxy_t; d2xy_t; d3xy_t], t_, t);

T = tf/2;
precision = 1e-2;
scaler = -(1/T)*log(precision);
poles_ = {-scaler*ones(3, 1), -scaler*ones(3, 1)};
is_dyn_control = true;

% [x; y; phi; v; omega; dv]
x0 = [1; 1; pi; 1; 0; 0];

% PWM frequency
n_s = 15;
Ts = n_s*dt;

% Noise standard deviation
sigma_noise = 0.01;

m = length(sys.descrip.u);

clear u_control

% options = struct('');
% options = struct('sigma_noise', sigma_noise);
% options = struct('Ts', Ts);
% options = struct('model_params', sys.descrip.model_params);
% options.model_params(2) = 0.06;

n_f = 2;
frequency = 2*pi/(n_f*T_traj);
amplitude = 1;

options = struct('frequency', frequency, ...
                 'amplitude', amplitude);

calc_u_func = @() calc_control_2DRobot(sys, poles_);
u_func = @(t, qp) u_control(t, qp, ref_func, ...
                            sys, calc_u_func, options);
sol = validate_model(sys, t, x0, u_func, is_dyn_control);

sol = sol';
t = t';

run([pwd, '/plot_nonhol.m']);

