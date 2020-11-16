FontSize = 25;

q_sym = sys.kin.q;
p_sym = sys.kin.p{end};

q = sol(:, 1:length(q_sym));
p = sol(:, length(q_sym)+1:length(q_sym)+length(p_sym));

% States and speed update

% x y theta timelapse
plot_config.titles = repeat_str('', 3);
plot_config.xlabels = {'', '', 't [s]'};
plot_config.ylabels = {'$x(t)$', '$y(t)$', '$\theta(t)$'};
plot_config.grid_size = [3, 1];

[h_xyth, axs] = my_plot(tspan, q(:, 1:3), plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;
axs{1}{3}.FontSize = FontSize;

w_sym = sys.descrip.syms(end-2);
L_sym = sys.descrip.syms(end-3);

w_val = sys.descrip.model_params(end-2);
L_val = sys.descrip.model_params(end-3);

syms_delta = [delta_i, delta_o, w_sym, L_sym];
deltas = [];

wb = my_waitbar('Calculating delta...');

n_t = length(tspan);

for i = 1:2
    sol_i = sol(i, 4:5);
    vals_delta = [];
    delta_ = subs(delta_sym, syms_delta, [sol_i, w_val, L_val]);
    deltas = [deltas; delta_];

    wb.update_waitbar(i, n_t);
end

% delta_i delta_o time lapse
base_legend_delta_i = {'$\delta_i$', '$\delta_i^{min}$', '$\delta_i^{max}$'};
base_marker_delta_i = {'-', 'm--', 'r--'};
base_legend_delta_o = {'$\delta_o$', '$\delta_o^{min}$', '$\delta_o^{max}$'};
base_marker_delta_o = {'-', 'm--', 'r--'};

plot_config.titles = repeat_str('', 3);
plot_config.xlabels = {'', '', 't [s]'};
plot_config.ylabels = {'$\delta_i(t)$', ...
                       '$\delta_o(t)$', ...
                       '$\delta(t)$'};
plot_config.grid_size = [3 1];
plot_config.legends = {base_legend_delta_i, base_legend_delta_o};
plot_config.pos_multiplots = [1, 1, 2, 2];
plot_config.markers = {base_marker_delta_i, base_marker_delta_o};

n_deltas = length(q(:, 4:5));

deltas_max = MAX_DELTA*ones([n_deltas, 1]);
deltas_vec = [-deltas_max, deltas_max, -deltas_max, deltas_max];

delta_i_o_ = [q(:, 4:5), deltas];
plot_data = {delta_i_o_, deltas_vec};

[h_deltas, axs] = my_plot(tspan, plot_data, plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;
axs{1}{3}.FontSize = FontSize;

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = {'', '', '', 't [s]'};
plot_config.ylabels = {'$\phi_i(t)$', '$\phi_o(t)$', ...
                       '$\phi_r(t)$', '$\phi_l(t)$'};
plot_config.grid_size = [2, 2];
                   
[h_phis, axs] = my_plot(tspan, q(:, 6:end), plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;
axs{1}{3}.FontSize = FontSize;
axs{1}{4}.FontSize = FontSize;

plot_config.titles = repeat_str('', 2);
plot_config.xlabels = {'', 't [s]'};
plot_config.ylabels = {'$\omega_{\delta_i}(t)$', '$\omega_l(t)$'};
plot_config.grid_size = [2, 1];

[h_omegas, axs] = my_plot(tspan, p, plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;

% ------------------------------------------------------

h_xy = my_figure();

axs = plot(q(:, 1), q(:, 2), '-');
hold off;

xlabel('x [m]', 'interpreter', 'latex');
ylabel('y [m]', 'interpreter', 'latex');

axs.Parent.FontSize = FontSize;

axis equal
grid

files_ = ls([pwd, '/..']);
files = strsplit(files_);

has_imgs = false;
for i = 1:length(files)
    file_ = files{i};
    if(strcmp(file_, 'imgs'))
        has_imgs = true;
    end
end

if(~has_imgs)
    mkdir([pwd, '/imgs']);
end

% hfig_consts = plot_constraints(sys, tspan, sol);

A = sym('A_', [3, 3]);
[m, n] = size(A);

inv_A = inv(A);
H = sys.dyn.H;

A_reshaped = reshape(A, [m*n, 1]);
H_reshaped = reshape(H, [m*n, 1]);
inv_H  = subs(inv_A, A_reshaped, H_reshaped);

u = sys.descrip.u;
h = sys.dyn.h;
Z = sys.dyn.Z;
C = sys.kin.C;
q_sym = sys.kin.q;
p_sym = sys.kin.p{end};

symbs = sys.descrip.syms;
model_params = sys.descrip.model_params;

sym_vars = [symbs.'; u];
num_vars = [model_params.'; zeros(size(u))];

plant_sym = [C*p_sym; inv_H*(-h + Z*u)];
plant = subs(plant_sym, sym_vars, num_vars);

n_t = length(tspan);

wb = my_waitbar('Derivatives');

dqps = [];
for i = 1:n_t
    x_i = sol(i, :)';
    dqp = double(subs(plant, [q_sym; p_sym], x_i))';

    dqps = [dqps; dqp];

    wb.update_waitbar(i, n_t);
end

wb.close_window();

plot_config.titles = repeat_str('', 3);
plot_config.xlabels = repeat_str('', 3);
plot_config.ylabels = {'$\dot{x}(t)$', '$\dot{y}(t)$', '$\dot{\theta}(t)$'};
plot_config.grid_size = [3, 1];

dxyth = dqps(:, 1:3);

[h_dxyth, axs] = my_plot(tspan, dxyth, plot_config);

plot_config.titles = repeat_str('', 2);
plot_config.xlabels = repeat_str('', 2);
plot_config.ylabels = {'$\dot{\delta_i}(t)$', '$\dot{\delta_o}(t)$'};
plot_config.grid_size = [2, 1];

ddeltas = dqps(:, 4:5);

[h_ddeltas, axs] = my_plot(tspan, ddeltas, plot_config);

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = repeat_str('', 4);
plot_config.ylabels = {'$\dot{\phi_i}(t)$', '$\dot{\phi_o}(t)$', ...
                       '$\dot{\phi_r}(t)$', '$\dot{\phi_l}(t)$'};
plot_config.grid_size = [2, 2];

dphis = dqps(:, 10:13);

[h_dphis, axs] = my_plot(tspan, dphis, plot_config);

plot_config.titles = repeat_str('', 3);
plot_config.xlabels = repeat_str('', 3);
plot_config.ylabels = {'$\dot{\omega_{\theta}}(t)$', '$\dot{\omega_{\delta_i}}(t)$', '$\dot{\omega_{\phi_l}}(t)$'};
plot_config.grid_size = [3, 1];

domegas = dqps(:, 6:length(sys.kin.q));

[h_domegas, axs] = my_plot(tspan, domegas, plot_config);

n_q = length(sys.kin.q);
n_p = length(sys.kin.p{end});
n_t = length(tspan);

radii = [];
q = sys.kin.q;
p = sys.kin.p{end};
symbs = sys.descrip.syms;
params = sys.descrip.model_params;

wb = my_waitbar('');
radii_i = [radius_i, radius_o, radius_r, radius_l];
radii_i = subs(radii_i, symbs.', params.');

for i = 1:n_t
    q_i = sol(i, 1:n_q)';
    radii_i = subs(radii_i, q, q_i);
    radii = [radii; radii_i];
    wb.update_waitbar(i, n_t);
end

[~, qp, ~] = states_to_q_qp_p(sys, sol);

wb = my_waitbar('');
R = sys.descrip.model_params(end-4);

angular_vels = [];
for i = 1:n_t
    phip_i = qp(i, 6);
    phip_o = qp(i, 7);
    phip_r = qp(i, 8);
    phip_l = qp(i, 9);
    
    radius_i = radii(i, 1);
    radius_o = radii(i, 2);
    radius_r = radii(i, 3);
    radius_l = radii(i, 4);
    
    angular_vel = [R*phip_i/radius_i, ...
                   R*phip_o/radius_o, ...
                   R*phip_r/radius_r, ...
                   R*phip_l/radius_l];

    angular_vels = [angular_vels; angular_vel];

    wb.update_waitbar(i, n_t);
end

plot_config.titles = repeat_str('', 1);
plot_config.xlabels = repeat_str('', 1);
plot_config.ylabels = {''};
plot_config.grid_size = [1, 1];
plot_config.legends = {'$\dot\phi_i$', '$\dot\phi_o$', ...
                       '$\dot\phi_r$', '$\dot\phi_l$'};
plot_config.pos_multiplots = [1, 1, 1];
plot_config.markers = {'-', '--', '.-', '*-'};

plot_data = {angular_vels(:, 1), angular_vels(:, 2:end)};

[h_angvals, axs] = my_plot(tspan, plot_data, plot_config);

run('./calc_angular_speed.m');

plot_config.titles = repeat_str('', 1);
plot_config.xlabels = repeat_str('', 1);
plot_config.ylabels = {''};
plot_config.grid_size = [1, 1];
plot_config.legends = {'$r_i$', '$r_o$', '$r_r$', '$r_l$', '$r_g$'};
plot_config.pos_multiplots = [1, 1, 1, 1];
plot_config.markers = {'-', 'b--', 'r--', 'k--', 'g--'};

angular_data = {w_vals(:, 1), w_vals(:, 2:end)};

[h_angvals, axs] = my_plot(tspan(1:n_f), angular_data, plot_config);

plot_config.titles = repeat_str('', 1);
plot_config.xlabels = repeat_str('', 1);
plot_config.ylabels = {''};
plot_config.grid_size = [1, 1];
plot_config.legends = {'Constraint 1', 'Constraint 2', ...
                       'Constraint 3', 'Constraint 4', ...
                       'Constraint 5'};
plot_config.pos_multiplots = [1, 1, 1, 1];
plot_config.markers = {'-', 'b--', 'r--', 'k--', 'g--'};

unhol_consts_data = {unhol_consts(:, 1), unhol_consts(:, 2:end)};

[h_unhol, axs] = my_plot(tspan(1:n_f), unhol_consts_data, plot_config);

saveas(h_xyth, ['../imgs/xy_theta_plot', '.eps'], 'epsc');
saveas(h_deltas, ['../imgs/deltas', '.eps'], 'epsc');
saveas(h_omegas, ['../imgs/omegas', '.eps'], 'epsc');
saveas(h_phis, ['../imgs/phis', '.eps'], 'epsc');
saveas(h_xyth, ['../imgs/x_y_theta', '.eps'], 'epsc');
saveas(h_xyth, ['../imgs/consts', '.eps'], 'epsc');

