close all


% ----- States and reference plot ------

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = {'', '$t$ [s]'};
plot_config.ylabels = {'$x_1$', '$\dot{x}_1$'};
plot_config.grid_size = [2, 1];
plot_config.legends = {{'$x_1$', '$x_1^{\star}$'}};
plot_config.pos_multiplots = [1];
plot_config.markers = {{'-', '--'}};

plot_data = {states, traj(:, 1)};

hfig_states = my_plot(tspan, plot_data, plot_config);

% --------------------------------------

saveas(hfig_states, ['../imgs/states'], 'epsc');

