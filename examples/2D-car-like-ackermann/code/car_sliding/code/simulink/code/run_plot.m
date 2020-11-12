FontSize = 25;

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

% delta_i delta_o time lapse
base_legend_delta_i = {'$\delta_i$', '$\delta_i^{min}$', '$\delta_i^{max}$'};
base_marker_delta_i = {'-', 'm--', 'r--'};
base_legend_delta_o = {'$\delta_o$', '$\delta_o^{min}$', '$\delta_o^{max}$'};
base_marker_delta_o = {'-', 'm--', 'r--'};

plot_config.titles = repeat_str('', 2);
plot_config.xlabels = {'', 't [s]'};
plot_config.ylabels = {'$\delta_i(t)$', '$\delta_o(t)$'};
plot_config.grid_size = [2, 1];
plot_config.legends = {base_legend_delta_i, base_legend_delta_o};
plot_config.pos_multiplots = [1, 1, 2, 2];
plot_config.markers = {base_marker_delta_i, base_marker_delta_o};

n_deltas = length(q(:, 4:5));

deltas_max = MAX_DELTA*ones([n_deltas, 1]);
deltas_vec = [-deltas_max, deltas_max, ...
              -deltas_max, deltas_max];

plot_data = {q(:, 4:5), deltas_vec};

[h_deltas, axs] = my_plot(tspan, plot_data, plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;

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

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = {'', '', '', 't [s]'};
plot_config.ylabels = {'$\omega_{\theta}(t)$', '$\omega_o(t)$', ...
                       '$\omega_r(t)$', '$\omega_l(t)$'};
plot_config.grid_size = [2, 2];

[h_omegas, axs] = my_plot(tspan, p, plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;
axs{1}{3}.FontSize = FontSize;
axs{1}{4}.FontSize = FontSize;


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

saveas(h_xyth, ['../imgs/xy_theta_plot', '.eps'], 'epsc')
saveas(h_deltas, ['../imgs/deltas', '.eps'], 'epsc')
saveas(h_omegas, ['../imgs/omegas', '.eps'], 'epsc')
saveas(h_phis, ['../imgs/phis', '.eps'], 'epsc')
saveas(h_xyth, ['../imgs/x_y_theta', '.eps'], 'epsc')

