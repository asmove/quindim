% Params and parameters estimation
model_params = sys.descrip.model_params.';
imprecision = perc*ones(size(sys.descrip.syms))';
params_lims = [(1-imprecision).*model_params, ...
               (1+imprecision).*model_params];

rel_qqbar = sys.kin.q;

[m, ~] = size(sys.dyn.Z);
phi = 300;

% Control action
eta = ones(m, 1);
poles = -ones(m, 1);
u = sliding_underactuated(sys, eta, poles, params_lims, rel_qqbar, is_sat);

len_params = length(sys.descrip.model_params);

% Initial values
x0 = [0; 0];

% Tracking values
x_d = @(t) [pi; 0];
x_xp_d = @(t) [x_d(t); 0];

% Initial conditions
tf = 5;
dt = 0.01;
tspan = 0:dt:tf;

df_h = @(t, x) df_sys(t, x, x_xp_d, u, sys, tf);
sol = my_ode45(df_h, tspan, x0);
[m, ~] = size(sys.dyn.Z);

% Plot part
img_path = '../imgs/';

x = sol(1:end, :);

t_len = length(tspan);

q_p_s = [sys.kin.q; sys.kin.p];
q_p_d_s = add_symsuffix([q_p_s; sys.kin.pp], '_d');

[~, m] = size(sys.dyn.Z);

q_p = [sys.kin.q; sys.kin.p];
n = length(q_p);

% States plot
plot_config.titles = repeat_str('', n);
plot_config.xlabels = repeat_str('t [s]', n);
plot_config.ylabels = {'$\theta$ [m]', '$\dot{\theta}$ [m/s]'};
plot_config.grid_size = [1, 2];

hfigs_x = my_plot(tspan, x', plot_config);

% Input plot
plot_config.titles = {'', ''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u$ [N]'};
plot_config.grid_size = [1, 1];

t_u = linspace(0, tf, length(u_control));
hfigs_u = my_plot(t_u, u_control, plot_config);

% Sliding function plot
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'Sliding function $s$'};
plot_config.grid_size = [1, 1];

s = [];

alpha_ = u.alpha;
lambda = u.lambda;

t_s = linspace(0, tf, length(sliding_s));
hfigs_s = my_plot(t_s', sliding_s, plot_config);

if(u.is_sat)
    posfix = '_sat';
else
    posfix = '_deg';
end

% States
saveas(hfigs_x, ['../imgs/x_', int2str(100*perc), posfix, '.eps'], 'eps');

% States
saveas(hfigs_u, ['../imgs/u_', int2str(100*perc), posfix, '.eps'], 'eps');

% Sliding function
saveas(hfigs_s, ['../imgs/s_', int2str(100*perc), posfix, '.eps'], 'eps');
