% States and speed update
base_legend = {'Ideal', 'Non-ideal'};
base_marker = {'-', '--'};

q = simOut.coordinates.signals.values;
p = simOut.speeds.signals.values;
states = simOut.states.signals.values;
q_speeds = simOut.q_speeds.signals.values;
tspan = simOut.tout;

FontSize = 25;

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
plot_config.titles = repeat_str('', 2);
plot_config.xlabels = {'', 't [s]'};
plot_config.ylabels = {'$\delta_i(t)$', '$\delta_o(t)$'};
plot_config.grid_size = [2, 1];

[h_deltas, axs] = my_plot(tspan, q(:, 4:5), plot_config);

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

plot_config.titles = repeat_str('', 3);
plot_config.xlabels = {'', '', 't [s]'};
plot_config.ylabels = {'$\omega_o(t)$', '$\omega_r(t)$', '$\omega_l(t)$'};
plot_config.grid_size = [3, 1];

[h_omegas, axs] = my_plot(tspan, p, plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;
axs{1}{3}.FontSize = FontSize;

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
saveas(h_xy, ['../imgs/phis', '.eps'], 'epsc')

