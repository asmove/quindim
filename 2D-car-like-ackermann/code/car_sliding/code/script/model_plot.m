% States and speed update
base_legend = {'Ideal', 'Non-ideal'};
base_marker = {'-', '--'};

FontSize = 25;

plot_config.titles = repeat_str('', 3);
plot_config.xlabels = {'', '', 't [s]'};
plot_config.ylabels = {'$x(t)$', '$y(t)$', '$\theta(t)$'};
plot_config.grid_size = [3, 1];
plot_config.legends = {base_legend, base_legend, base_legend};
plot_config.pos_multiplots = [1, 2, 3];
plot_config.markers = {base_marker, base_marker, base_marker};

qs = {xout_ideal(:, 1:3), xout_nonideal(:, 1:3)};

[h_xyth, axs] = my_plot(tspan, qs, plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;
axs{1}{3}.FontSize = FontSize;

plot_config.titles = repeat_str('', 2);
plot_config.xlabels = {'', 't [s]'};
plot_config.ylabels = {'$\delta_i(t)$', '$\delta_o(t)$'};
plot_config.grid_size = [2, 1];
plot_config.legends = {base_legend, base_legend};
plot_config.pos_multiplots = [1, 2];
plot_config.markers = {base_marker, base_marker};

qs = {xout_ideal(:, 4:5), xout_nonideal(:, 4:5)};

[h_deltas, axs] = my_plot(tspan, qs, plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = {'', '', '', 't [s]'};
plot_config.ylabels = {'$\phi_i(t)$', '$\phi_o(t)$', ...
                       '$\phi_r(t)$', '$\phi_l(t)$'};
plot_config.grid_size = [2, 2];
plot_config.legends = {base_legend, base_legend, ...
                       base_legend, base_legend};
plot_config.pos_multiplots = [1, 2, 3, 4];
plot_config.markers = {base_marker, base_marker, ...
                       base_marker, base_marker};
                   
qs = {xout_ideal(:, 6:9), xout_nonideal(:, 6:9)};

[h_phis, axs] = my_plot(tspan, qs, plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;
axs{1}{3}.FontSize = FontSize;
axs{1}{4}.FontSize = FontSize;

plot_config.titles = repeat_str('', 3);
plot_config.xlabels = {'', '', 't [s]'};
plot_config.ylabels = {'$\omega_o(t)$', '$\omega_r(t)$', '$\omega_l(t)$'};
plot_config.grid_size = [3, 1];
plot_config.legends = {base_legend, base_legend, base_legend};
plot_config.pos_multiplots = [1, 2, 3];
plot_config.markers = {base_marker, base_marker, base_marker};
                   
qs = {xout_ideal(:, 10:end), xout_nonideal(:, 10:end)};

[h_omegas, axs] = my_plot(tspan, qs, plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;
axs{1}{3}.FontSize = FontSize;

% ------------------------------------------------------

h_xy = my_figure();

axs = plot(xout_ideal(:, 1), xout_ideal(:, 2), '-');
hold on;
plot(xout_nonideal(:, 1), xout_nonideal(:, 2), '--');
hold off;

legend(base_legend, 'interpreter', 'latex');
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
saveas(h_xy, ['../imgs/phis', '.eps'], 'epsc')

