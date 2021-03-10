tspan = (0:dt:tf)';

n_t = length(tspan);
w_vec = w_n*ones(n_t, 1);

y = {[yrs, xs], [w_vec, xhats]};

markers = {'-', '--'};

plot_config.titles = repeat_str('', 3);
plot_config.xlabels = [repeat_str('', 3), 't [s]'];
plot_config.ylabels = {'$\tau$ [N $\cdot$ m]', ...
                       '$\omega$ [$\frac{rad}{s}$]', ...
                       '$i$ [A]'};
plot_config.legends = {{'$\tau(t)$', '$\tau^{\star}(t)$'}, ...
                       {'$\omega(t)$', '$\hat{\omega}(t)$'}, ...
                       {'$i(t)$', '$\hat{i}(t)$'}};
plot_config.plot_type = 'stairs';
plot_config.grid_size = [1, 3];
plot_config.pos_multiplots = [1, 2, 3];
plot_config.markers = {markers, markers, markers};

[hfig_x, axs] = my_plot(tspan, y, plot_config);

axs{1}{1}.FontSize = 25;
axs{1}{2}.FontSize = 25;
axs{1}{3}.FontSize = 25;

axis(axs{1}{1}, 'square');
axis(axs{1}{2}, 'square');
axis(axs{1}{3}, 'square');

plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$V$ [V]'};
plot_config.plot_type = 'stairs';
plot_config.grid_size = [1, 1];

[hfig_u, axs] = my_plot(tspan, us, plot_config);

axs{1}{1}.FontSize = 25;
axis(gca, 'square');

plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$\alpha$ [$\frac{\%}{100}$]'};
plot_config.plot_type = 'stairs';
plot_config.grid_size = [1, 1];
plot_config.legends = {'$\alpha(t)$', '$\alpha^{\star}(t)$'};
plot_config.plot_type = 'stairs';
plot_config.pos_multiplots = [1];
plot_config.markers = markers;

alphas_ref = alpha_ref*ones(n_t, 1);

ys = {alphas_ref, alphas};

[hfig_alpha, axs] = my_plot(tspan, ys, plot_config);

axs{1}{1}.FontSize = 25;
axis(gca, 'square');

saveas(hfig_x, '../imgs/states', 'epsc');
saveas(hfig_u, '../imgs/input', 'epsc');
saveas(hfig_alpha, '../imgs/alpha', 'epsc');
