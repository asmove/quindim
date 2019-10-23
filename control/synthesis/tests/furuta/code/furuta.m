model_params = sys.descrip.model_params.';
imprecision = zeros(length(sys.descrip.model_params));

if(perc ~= 0)
    imprecision = perc*ones(size(sys.descrip.syms))';
else
    imprecision = zeros(size(sys.descrip.syms))';
end

params_lims = [(1-imprecision).*model_params, ...
               (1+imprecision).*model_params];

rel_qqbar = sys.kin.q(2);

n = length(sys.kin.q);
m = length(sys.descrip.u);

% Control action
eta = ones(m, 1);
poles = -ones(m, 1);
u = sliding_underactuated(sys, eta, poles, params_lims, rel_qqbar, false);

len_params = length(sys.descrip.model_params);

% Initial values
x0 = [0; 0.1; 0; 0];

% Tracking values
q_p_ref_fun = @(t) [0; 0; 0; 0];

% Initial conditions
tf = 1;
dt = 0.01;
tspan = 0:dt:tf;
df_h = @(t, x) df_sys(t, x, q_p_ref_fun, u, sys, tf);
sol = my_ode45(df_h, tspan, x0);

[m, ~] = size(sys.dyn.Z);

% Plot part
img_path = '../imgs/';

x = sol(1:end, :);

t_len = length(tspan);

q_p_s = [sys.kin.q; sys.kin.p];
q_p_d_s = add_symsuffix([q_p_s; sys.kin.pp], '_d');

[~, m] = size(sys.dyn.Z);

u_n = zeros(t_len, m);

q_p = [sys.kin.q; sys.kin.p];
n = length(q_p);

% States plot
plot_config.titles = repeat_str('', n);
plot_config.xlabels = repeat_str('t [s]', n);
plot_config.ylabels = {'$\theta_1$ [rad]', ...
                       '$\theta_2$ [rad]', ...
                       '$\dot{\theta}_1 [\frac{rad}{s}]$', ...
                       '$\dot{\theta}_2 [\frac{rad}{s}]$'};
plot_config.grid_size = [2, 2];

hfigs_x = my_plot(tspan, x', plot_config);

% Input plot
plot_config.titles = {'', ''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u$ [V]'};
plot_config.grid_size = [1, 1];

t = linspace(0, tf, length(u_control));
hfigs_u = my_plot(t, u_control, plot_config);

% Sliding function plot
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'Sliding function $s$'};
plot_config.grid_size = [1, 1];

s = [];

alpha_ = u.alpha;
lambda = u.lambda;

t = linspace(0, tf, length(sliding_s));
hfigs_s = my_plot(t, sliding_s, plot_config);

if(perc ~= 0)
    perc_str = '_inexact';
else
    perc_str = '_exact';
end

phi_str = ['_', int2str(phi)];

if(is_sat)
    sat_str = '_sat';
else
    sat_str = '_deg';
end

% States
x_str = ['../imgs/x', phi_str, perc_str, sat_str, '.eps'];
saveas(hfigs_x, x_str, 'epsc');

% States
u_str = ['../imgs/u', phi_str, perc_str, sat_str, '.eps'];
saveas(hfigs_u, u_str, 'epsc');

% Sliding function
s_str = ['../imgs/s', phi_str, perc_str, sat_str, '.eps'];
saveas(hfigs_s, s_str, 'epsc');