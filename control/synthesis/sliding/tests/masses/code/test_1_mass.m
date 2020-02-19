% Params and parameters estimation
model_params = sys.descrip.model_params.';
imprecision = perc*ones(size(sys.descrip.syms))';
params_lims = [(1-imprecision).*model_params, ...
               (1+imprecision).*model_params];

rel_qqbar = sys.kin.q;

[~, m] = size(sys.dyn.Z);
phi = 0.5;
phi_min = -0.5;
phi_max = 0.5;

% Control action
eta = 50*ones(m, 1);
poles = -10*ones(m, 1);
u = sliding_underactuated(sys, eta, poles, params_lims, ...
                          rel_qqbar);
u.switch_type = switch_type;

len_params = length(sys.descrip.model_params);

% Initial values
x0 = [0; 0];

% Tracking values
w = 1;
x_d = @(t) [sin(w*t); w*cos(w*t)];
x_xp_d = @(t) [x_d(t); -w^2*sin(w*t)];

% Initial conditions
tf = 2*pi/w;
dt = 0.01;
tspan = 0:dt:tf;

output_fun = @(t, x) output_sliding(t, x, x_xp_d, u, sys, tf);
sol = validate_model(sys, tspan, x0, output_fun, false);
x = sol';

[m, ~] = size(sys.dyn.Z);

% Plot part
img_path = '../imgs/';

t_len = length(tspan);

q_p_s = [sys.kin.q; sys.kin.p];
q_p_d_s = add_symsuffix([q_p_s; sys.kin.pp], '_d');

[~, m] = size(sys.dyn.Z);

q_p = [sys.kin.q; sys.kin.p];
n = length(q_p);

% States plot
x_ds = [];
for i = 1:length(tspan)
    x_ds = [x_ds; x_d(tspan(i))'];
end

plot_config.titles = repeat_str('', n);
plot_config.xlabels = {'t [s]', 't [s]'};
plot_config.ylabels = {'$x$ [m]', '$\dot{x}$ [m/s]'};
plot_config.grid_size = [2, 1];
plot_config.legends = {{'$x$', '$x_{\star}$'}, ...
                        {'$\dot{x}$', '$\dot{x}_{\star}$'}};
plot_config.pos_multiplots = [1, 2];
plot_config.markers = {{'-', '--'}, {'-', '--'}};

x_plots = {x, x_ds};

hfigs_x = my_plot(tspan, x_plots, plot_config);

% Input plot
plot_config.titles = {'', ''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u_1$ [N]'};
plot_config.grid_size = [1, 1];

t_u = linspace(0, tf, length(u_control));
hfigs_u = my_plot(t_u, u_control, plot_config);

% Error plot
x_tilde = [];
for i = 1:length(tspan) 
    t_i = tspan(i);
    x_d_i = x_d(t_i);
    x_i = sol(:,i);
    x_xd_tilde = x_i - x_d_i;    
    x_tilde = [x_tilde, x_xd_tilde(1)];
end

plot_config.titles = repeat_str('', 1);
plot_config.xlabels = repeat_str('t [s]', 1);
plot_config.ylabels = {'$\tilde{x}$ [m]'};
plot_config.grid_size = [1, 1];

hfigs_x = my_plot(tspan, x_tilde', plot_config);

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


posfix = u.switch_type;

% States
saveas(hfigs_x, ['../imgs/x_1_', int2str(100*perc), posfix, '.eps'], 'eps');

% States
saveas(hfigs_u, ['../imgs/u_1_', int2str(100*perc), posfix, '.eps'], 'eps');

% Sliding function
saveas(hfigs_s, ['../imgs/s_1_', int2str(100*perc), posfix, '.eps'], 'eps');
