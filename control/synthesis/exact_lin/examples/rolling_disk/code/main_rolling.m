% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');

% Ellipsoid trajectory
a = 1;
b = 1;
omega = 1;

syms t_;
k = 3;

xy_t = [cos(k*t_)*cos(t_); cos(k*t_)*sin(t_)];
dxy_t = diff(xy_t, t_);
d2xy_t = diff(dxy_t, t_);
d3xy_t = diff(d2xy_t, t_);

% pos, vel, accel, jerk
ref_func = @(t) subs([xy_t; dxy_t; d2xy_t; d3xy_t], t_, t);

poles_ = {[-5, -5, -5], [-5, -5, -5]};
is_dyn_control = true;

% [x; y; theta; phi; omega_theta; omega_phi; domega_phi]
x0 = [1; 1; 0; 0; 0; 1; 0];

tf = pi;
dt = 0.001;

n_pwm = 10;
T_pwm = n_pwm*dt;

% Time vector
t = 0:dt:tf;

calc_u_func = @() calc_control_rolling(sys, poles_);
u_func = @(t, qp) u_control(t, qp, ref_func, ...
                            sys, calc_u_func, T_pwm);
sol = validate_model(sys, t, x0, u_func, true);

rob_path = '~/github/Robotics4fun/';
sim_path = 'control/synthesis/exact_lin/examples/rolling_disk/code/';

run([rob_path, sim_path, 'plot_nonhol.m']);

