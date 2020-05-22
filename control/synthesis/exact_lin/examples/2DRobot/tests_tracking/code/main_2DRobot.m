clear all
close all
clc

run('~/github/Robotics4fun/examples/2D_unicycle/code/main.m');

syms t_ T;

P0 = [0; 0];
P1 = [1; 1];
theta0 = 0;
thetaf = pi/2;

% Time vector
tf = 0.5;
dt = 0.001;
t = 0:dt:tf;

T_traj = tf;

% % Flower trajectory
% k = 3;
% xy_t = [cos(k*t_)*cos(t_); cos(k*t_)*sin(t_)];

% % Line trajectory
% traj_type = 'line';
% xy_t = P0 + t_*(P1 - P0);

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

% ref_func = @(t) subs([xy_t; dxy_t; d2xy_t; d3xy_t], t_, t);

% Arc-line curve
traj_params = struct('');

v = norm(P1 - P0)/T_traj;

v_0 = v;
v_01 = v; 
v_1 = v;

% Percentage under AB distance
alpha_0 = 0.2;
alpha_1 = 0.2;

traj_params = traj_tangentAB(P0, P1, theta0, ...
                             v_0, v_01, v_1, ...
                             alpha_0, alpha_1);

traj_params = traj_params{1};

% Geometrical properties
arg0 = traj_params.arg0;
dCD = traj_params.dCD;
arg1 = traj_params.arg1;

r0 = traj_params.r0;
r1 = traj_params.r1;

v = (r0*arg0 + dCD + r1*arg1)/T_traj;
v_0 = v;
v_01 = v;
v_1 = v;

t_0 = traj_params.t_0;
t_01 = traj_params.t_01;
t_1 = traj_params.t_1;

traj_params = traj_tangentAB(P0, P1, theta0, v_0, v_01, v_1, alpha_0, alpha_1);
traj_params = traj_params{1};

ref_func = @(t) tangentAB_reffunc(t, traj_params);

n_T = 4;
T = tf/n_T;
precision = 1e-2;
limiter = -(1/T)*log(precision);
scaler = 1.5;
poles_ = {-scaler*limiter*ones(3, 1), ...
          -scaler*limiter*ones(3, 1)};
is_dyn_control = true;

% [x; y; phi; v; omega; dv]
x0 = [P0; theta0; 1; 0; 0];

m = length(sys.descrip.u);

clear u_control

options = struct('');

% options = struct('sigma_noise', sigma_noise);
% % Noise standard deviation
% sigma_noise = 0.01;

% options = struct('Ts', Ts);
% % PWM frequency
% n_s = 15;
% Ts = n_s*dt;

% options = struct('model_params', sys.descrip.model_params);

% options.model_params(2) = 0.06;
% 
% n_f = 2;
% frequency = 2*pi/(n_f*T_traj);
% amplitude = 1;
% 
% options = struct('frequency', frequency, ...
%                  'amplitude', amplitude);

calc_u_func = @() calc_control_2DRobot(sys, poles_);
u_func = @(t, qp) u_control(t, qp, ref_func, ...
                            sys, calc_u_func, ...
                            options);

sol = validate_model(sys, t, x0, u_func, is_dyn_control);

sol = sol';
t = t';

run([pwd, '/plot_nonhol.m']);

