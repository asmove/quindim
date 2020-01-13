x = (0:0.01:2*pi)';
y_s = sin(x);
y_e = exp(x);
y_c = cos(x);

plot_config.titles = {'Harmonic', 'Exponential'};
plot_config.xlabels = {'t [s]', 't [s]'};
plot_config.ylabels = {'$y(t)$', '$y(t)$'};
plot_config.grid_size = [2, 1];
plot_config.legends = {'$\sin(x)$', '$\cos(x)$'};
plot_config.pos_multiplots = 1;
plot_config.markers = {'-', '--'};

ys = {[y_s, y_e], y_c};

my_plot(x, ys, plot_config);
