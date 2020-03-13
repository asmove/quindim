% Params and parameters estimation
model_params = sys.descrip.model_params.';
imprecision = perc*ones(size(sys.descrip.syms))';
params_lims = [(1-imprecision).*model_params, ...
               (1+imprecision).*model_params];

rel_qqbar = sys.kin.q(1);

[n, m] = size(sys.dyn.Z);

% Control action
eta = 25*ones(m, 1);
poles = -10*ones(m, 1);

u = sliding_underactuated(sys, eta, poles, params_lims, rel_qqbar, is_sat);

len_params = length(sys.descrip.model_params);

% Initial values
x0 = [0; 0; 0; 0];

% Tracking values
w = 3;
x_d = @(t) [sin(w*t); w*cos(w*t)];
x_xp_d = @(t) [x_d(t); -w^2*sin(w*t)];

x_d = @(t) [sin(w*t); sin(w*t); w*cos(w*t); w*cos(w*t)];
x_xp_d = @(t) [x_d(t); -w^2*sin(w*t); -w^2*sin(w*t)];

phi = 1;

% Initial conditions
tf = 2*pi/w;
dt = 0.01;
tspan = 0:dt:tf;
df_h = @(t, x) df_sys(t, x, x_xp_d, u, sys, tf);
sol = my_ode45(df_h, tspan, x0);

[m, ~] = size(sys.dyn.Z);

% Plot part
img_path = '../imgs/';

x = sol(1:end, :);
x = [x(1, 1:end); x(3, 1:end); x(2, 1:end); x(4, 1:end)];

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
plot_config.ylabels = {'$x_1$ [m]', '$\dot{x}_1$ [m/s]', ...
                       '$x_2$ [m]', '$\dot{x}_2$ [m/s]'};
plot_config.grid_size = [2, 2];

hfigs_x = my_plot(tspan, x', plot_config);

% Input plot
plot_config.titles = {'', ''};
plot_config.xlabels = {'$u_1$ [N]'};
plot_config.ylabels = {'$u_1$ [N]'};
plot_config.grid_size = [2, 1];

t = linspace(0, tf, length(u_control));
hfigs_u = my_plot(t, u_control, plot_config);

% Sliding function plot
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'Sliding function $s_1$'};
plot_config.grid_size = [1, 1];

s = [];

alpha_ = u.alpha;
lambda = u.lambda;

t = linspace(0, tf, length(sliding_s));
hfigs_s = my_plot(t, sliding_s, plot_config);

if(is_sat)
    posfix = '_sat';
else
    posfix = '_deg';
end

% States
saveas(hfigs_x, ['../imgs/x_2_', int2str(100*perc), posfix, '.eps'], 'eps');

% Control input
saveas(hfigs_u, ['../imgs/u_2_', int2str(100*perc), posfix, '.eps'], 'eps');

% Sliding function
saveas(hfigs_s, ['../imgs/s_2_', int2str(100*perc), posfix, '.eps'], 'eps');