clear_inner_close_all()
clear u_control;
clear sliding_s;

% Params and parameters estimation
model_params = sys.descrip.model_params.';
imprecision = perc*ones(size(sys.descrip.syms))';
params_lims = [(1-imprecision).*model_params, ...
               (1+imprecision).*model_params];

rel_qqbar = sys.kin.q;

[~, m] = size(sys.dyn.Z);
n = length(sys.kin.q);

% Initial values
x0 = [0; 0.1];

% Tracking values
% w = 10;
% x_d = @(t) [sin(w*t); w*cos(w*t)];
% x_xp_d = @(t) [x_d(t); -w^2*sin(w*t)];
x_d = @(t) [1; 0];
x_xp_d = @(t) [x_d(t); 0];
x_d0 = x_d(0);

% Control parameters
pole = -10;
poles = pole*ones(m, 1);

E = equationsToMatrix(rel_qqbar, sys.kin.q);
alpha = E;
C = eig_to_matrix(poles);
lambda = -E*C;
s0 = subs(alpha*(x0(2) - x_d0(2)) + lambda*(x0(1) - x_d0(1)));
t_r = 0.5;
eta = abs(s0)/t_r;
etas = eta*ones(m, 1);

u = sliding_underactuated(sys, etas, poles, params_lims, rel_qqbar);
u.switch_type = switch_type;

m_min = params_lims(1, 1);
b_min = params_lims(2, 1);
k_min = params_lims(3, 1);

m_max = params_lims(1, 2);
b_max = params_lims(2, 2);
k_max = params_lims(3, 2);

symbs = sys.descrip.syms;
symbs_hat = add_symsuffix(sys.descrip.syms, '_hat');

m = symbs(1);
b = symbs(2);
k = symbs(3);

m_hat = symbs_hat(1);
b_hat = symbs_hat(2);
k_hat = symbs_hat(3);

u.Ms_struct.D = u.Ms_struct.F/u.Ms_struct.den_D;
u.Ms_struct.C = inv(eye(n)- u.Ms_struct.D);
u.Fs_struct.Fs_num = subs(u.Fs_struct.Fs_num, ...
                          [m b k m_hat b_hat k_hat], ...
                          [m_min b_max k_max m_max b_min k_min]);
u.Fs_struct.Fs = u.Fs_struct.Fs_num/u.Fs_struct.Fs_den;

if(strcmp(switch_type, 'sat'))
    u.phi = 1;
elseif(strcmp(switch_type, 'hyst'))
    u.phi_min = -0.5;
    u.phi_max = 0.5;
elseif(strcmp(switch_type, 'poly'))
    u.phi = 1;
    u.degree = 2;
else
end

len_params = length(sys.descrip.model_params);

% Initial conditions
dt = 0.005;
tf = 1;
tspan = 0:dt:tf;

output_fun = @(t, x) output_sliding(t, x, x_xp_d, u, sys, tf, dt);
% output_fun = @(t, x) 0;
sol = validate_model(sys, tspan, x0, output_fun, false);

x = sol';
tspan = tspan'; 

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
x_plots = {double(x), double(x_ds)};

hfigs_x = my_plot(tspan, double(x), plot_config);

% Input plot
plot_config.titles = {'', ''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u_1$ [N]'};
plot_config.grid_size = [1, 1];

t_u = linspace(0, tf, length(u_control));
hfigs_u = my_plot(t_u, double(u_control), plot_config);
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

hfigs_x = my_plot(tspan, double(x_tilde'), plot_config);

% Sliding function plot
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'Sliding function $s$'};
plot_config.grid_size = [1, 1];

t_s = linspace(0, tf, length(sliding_s));
hfigs_s = my_plot(t_s', double(sliding_s), plot_config);

posfix = u.switch_type;

% States
saveas(hfigs_x, ['../imgs/x_1_', int2str(100*perc), posfix, '.eps'], 'eps');

% States
saveas(hfigs_u, ['../imgs/u_1_', int2str(100*perc), posfix, '.eps'], 'eps');

% Sliding function
saveas(hfigs_s, ['../imgs/s_1_', int2str(100*perc), posfix, '.eps'], 'eps');
