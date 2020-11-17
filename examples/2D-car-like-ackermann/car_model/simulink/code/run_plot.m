FontSize = 25;

q_sym = sys.kin.q;
p_sym = sys.kin.p{end};

q = sol(:, 1:length(q_sym));
p = sol(:, length(q_sym)+1:length(q_sym)+length(p_sym));

% States and speed update

% %%%%%%%%%%%%%%%%%% x y theta timelapse %%%%%%%%%%%%%%%%%%
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

for i = 1:n_t
    sol_i = sol(i, 4:5);
    vals_delta = [];
    delta_ = subs(delta_sym, syms_delta, [sol_i, w_val, L_val]);
    deltas = [deltas; delta_];

    wb.update_waitbar(i, n_t);
end

% %%%%%%%%%%%%%%%%%% delta_i delta_o time lapse %%%%%%%%%%%%%%%%%%
base_legend_delta = {'$\delta$', '$\delta^{min}$', '$\delta^{max}$', ...
                     '$\delta_i$', '$\delta_o$'};
base_marker_delta = {'r-', 'b--', 'm--', 'b-', 'g-'};

plot_config.titles = repeat_str('', 1);
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$\delta_i(t)$, $\delta_i(t)$'};
plot_config.grid_size = [1 1];
plot_config.legends = {base_legend_delta};
plot_config.pos_multiplots = [1, 1, 1, 1];
plot_config.markers = {base_marker_delta};

n_deltas = length(q(:, 4:5));

deltas_max = MAX_DELTA*ones([n_deltas, 1]);
deltas_vec = [-deltas_max, deltas_max, delta_i_o_, q(:, 4:5)];
plot_data = {deltas, deltas_vec};

[h_deltas, axs] = my_plot(tspan, plot_data, plot_config);

axs{1}{1}.FontSize = FontSize;

% %%%%%%%%%%%%%%%%%% Phis timelapse %%%%%%%%%%%%%%%%%%

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = {'', '', '', 't [s]'};
plot_config.ylabels = {'$\phi_i(t)$', '$\phi_o(t)$', ...
                       '$\phi_r(t)$', '$\phi_l(t)$'};
plot_config.grid_size = [2, 2];
                   
[h_phis, axs] = my_plot(tspan, q(:, 6:end), plot_config);

% %%%%%%%%%%%%%%%%%% Omegas timelapse %%%%%%%%%%%%%%%%%%

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

% %%%%%%%%%%%%%%%%%% xy timelapse %%%%%%%%%%%%%%%%%%

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

% %%%%%%%%%%%%%%%%%% Constraints timelapse %%%%%%%%%%%%%%%%%%

% hfig_consts = plot_constraints(sys, tspan, sol);

% %%%%%%%%%%%%%%%%%% plant derivative timelapse %%%%%%%%%%%%%%%%%%

A = sym('A_', size(sys.dyn.H));
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

n_t = length(tspan);

% wb = my_waitbar('Derivatives');
% 
% qp_vars = [q_sym; p_sym; delta];
% 
% delta_sym = subs(delta_sym, symbs, model_params);
% 
% n_q = length(q_sym);
% n_p = length(p_sym);
% 
% dqps = [];
% for i = 1:n_t
%     q_i = sol(i, 1:n_q)';
%     p_i = sol(i, n_q+1:end)';
%     
%     delta_val = my_subs(delta_sym, qp_vars, [q_i; p_i; delta_val]);
%     qp_vals = [q_i; p_i; delta_val];
%     
%     dqp = double(my_subs(plant, qp_vars, qp_vals))';
%     
%     dqps = [dqps; dqp];
% 
%     wb.update_waitbar(i, n_t);
% end
% 
% % %%%%%%%%%%%%%%%%%% x y theta timelapse %%%%%%%%%%%%%%%%%%
% 
% plot_config.titles = repeat_str('', 3);
% plot_config.xlabels = repeat_str('', 3);
% plot_config.ylabels = {'$\dot{x}(t)$', '$\dot{y}(t)$', '$\dot{\theta}(t)$'};
% plot_config.grid_size = [3, 1];
% 
% dxyth = dqps(:, 1:3);
% 
% [h_dxyth, axs] = my_plot(tspan, dxyth, plot_config);
% 
% % %%%%%%%%%%%%%%%%%% delta_i delta_o timelapse %%%%%%%%%%%%%%%%%%
% 
% plot_config.titles = repeat_str('', 2);
% plot_config.xlabels = repeat_str('', 2);
% plot_config.ylabels = {'$\dot{\delta_i}(t)$', '$\dot{\delta_o}(t)$'};
% plot_config.grid_size = [2, 1];
% 
% ddeltas = dqps(:, 4:5);
% 
% [h_ddeltas, axs] = my_plot(tspan, ddeltas, plot_config);
% 
% % %%%%%%%%%%%%%%%%%% dot phi timelapse %%%%%%%%%%%%%%%%%%
% 
% plot_config.titles = repeat_str('', 4);
% plot_config.xlabels = repeat_str('', 4);
% plot_config.ylabels = {'$\dot{\phi_i}(t)$', '$\dot{\phi_o}(t)$', ...
%                        '$\dot{\phi_r}(t)$', '$\dot{\phi_l}(t)$'};
% plot_config.grid_size = [2, 2];
% 
% dphis = dqps(:, 6:9);
% 
% [h_dphis, axs] = my_plot(tspan, dphis, plot_config);
% 
% % %%%%%%%%%%%%%%%%%% dot omega timelapse %%%%%%%%%%%%%%%%%%
% 
% plot_config.titles = repeat_str('', 2);
% plot_config.xlabels = repeat_str('', 2);
% plot_config.ylabels = {'$\dot{\omega_{\delta_o}}(t)$', '$\dot{\omega_{\phi_l}}(t)$'};
% plot_config.grid_size = [3, 1];
% 
% domegas = dqps(:, 10:end);
% 
% [h_domegas, axs] = my_plot(tspan, domegas, plot_config);
% saveas(h_dxyth, ['../imgs/dxyth', '.eps'], 'epsc');
% saveas(h_ddeltas, ['../imgs/ddeltas', '.eps'], 'epsc');
% saveas(h_dphis, ['../imgs/dphis', '.eps'], 'epsc');
% saveas(h_domegas, ['../imgs/domegas', '.eps'], 'epsc');

% %%%%%%%%%%%%%%%%%% Car angular speed timelapse %%%%%%%%%%%%%%%%%%

run('./calc_angular_speed.m');

plot_config.titles = repeat_str('', 1);
plot_config.xlabels = repeat_str('', 1);
plot_config.ylabels = {'$r$ $[rad/s]$'};
plot_config.grid_size = [1, 1];
plot_config.legends = {'$r_i$', '$r_o$', '$r_r$', '$r_l$', '$r_g$'};
plot_config.pos_multiplots = [1, 1, 1, 1];
plot_config.markers = {'-', 'b--', 'r--', 'k--', 'g--'};

angular_data = {w_vals(:, 1), w_vals(:, 2:end)};

[h_angvals, axs] = my_plot(tspan(1:n_f), angular_data, plot_config);

saveas(h_xyth, ['../imgs/xy_theta_plot', '.eps'], 'epsc');
saveas(h_deltas, ['../imgs/deltas', '.eps'], 'epsc');
saveas(h_omegas, ['../imgs/omegas', '.eps'], 'epsc');
saveas(h_phis, ['../imgs/phis', '.eps'], 'epsc');
saveas(h_xy, ['../imgs/xy_cartesian', '.eps'], 'epsc');
saveas(h_angvals, ['../imgs/car_rotation', '.eps'], 'epsc');

