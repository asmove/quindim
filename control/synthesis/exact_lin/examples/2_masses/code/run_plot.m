close all


% ----- States and reference plot ------

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = {'', '$t$ [s]', '', '$t$ [s]'};
plot_config.ylabels = {'$x_1$', '$x_2$', ...
                       '$\dot{x}_1$', '$\dot{x}_2$'};
plot_config.grid_size = [2, 2];
plot_config.legends = {{'$x_1$', '$x_1^{\star}$'}, ...
                       {'$\dot{x}_1$', '$\dot{x}_1^{\star}$'}};
plot_config.pos_multiplots = [1, 3];
plot_config.markers = {{'-', '--'}, {'-', '--'}};

plot_data = {states, [traj(:, 1), traj(:, 2)]};

[hfig_states, axs] = my_plot(tspan, plot_data, plot_config);

axs{1}{1}.FontSize = 20;
axs{1}{2}.FontSize = 20;
axs{1}{3}.FontSize = 20;
axs{1}{4}.FontSize = 20;

% --------------------------------------

saveas(hfig_states, ['../imgs/states'], 'epsc');

