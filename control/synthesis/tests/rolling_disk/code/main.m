% clear all
% close all
% clc
% 
% %run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');
% run('C:\Users\brunolnetto\Documents\github\Robotics4fun\examples\rolling_disk\code\main.m')

len_params = length(sys.descrip.model_params);

% Initial values
x0 = [1; 0; pi/4; 0];

% Initial conditions
tf = 5;
dt = 0.1;
tspan = 0:dt:tf;

V = 0.5*(sys.kin.q(1)^2 + sys.kin.q(2)^2);
Eta = ones(2, 1);
Eta = diag(Eta);

df_h = @(t, q) df_unhol(t, q, sys, tf, Eta, V);
sol = my_ode45(df_h, tspan, x0);
[m, ~] = size(sys.dyn.Z);

% Plot part
img_path = '../imgs/';

x = sol(1:end, :);

t_len = length(tspan);

if(length(sys.kin.p) ~= 1)
    p = sys.kin.p{end};
    pp = sys.kin.pp{end};
else
    p = sys.kin.p;
    pp = sys.kin.pp;
end    

q_p_s = [sys.kin.q; p];

[~, m] = size(sys.dyn.Z);

q_p = [sys.kin.q; p];
n = length(q_p);

% States plot
n = length(sys.kin.q) + length(sys.kin.p{2});
plot_config.titles = repeat_str('', n);
plot_config.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_config.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$'};
plot_config.grid_size = [2, 2];

hfigs_x = my_plot(tspan, x', plot_config);

% Input plot
plot_config.titles = {'', ''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u$ [N.m]'};
plot_config.grid_size = [1, 1];

t_u = linspace(0, tf, length(u_control));
hfigs_u = my_plot(t_u, u_control, plot_config);

% States
saveas(hfigs_x, ['../imgs/x.eps'], 'eps');

% States
saveas(hfigs_u, ['../imgs/u.eps'], 'eps');

