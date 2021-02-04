% Generalized coordinates
plot_info_q.titles = repeat_str('', 2);
plot_info_q.xlabels = {'', '', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$'};
plot_info_q.grid_size = [2, 1];

hfigs_states = my_plot(t, x(:, 1:2), plot_info_q);

plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = {'', '$t$ [s]'};
plot_info_p.ylabels = {'$\dot{x}$', '$\dot{y}$'};
plot_info_p.grid_size = [2, 1];

% Generalized coordinates
plot_info_xy.titles = repeat_str('', 1);
plot_info_xy.xlabels = {'$x$'};
plot_info_xy.ylabels = {'$y$'};
plot_info_xy.grid_size = [1, 1];

hfigs_xy = my_plot(x(:, 1), x(:, 2), plot_info_xy);

% States plot
hfigs_speeds = my_plot(t, x(:, 3:4), plot_info_p);

% Energies plot
hfig_energies = plot_energies(sys, t, x);

% Images
saveas(hfig_energies, '../imgs/energies', 'epsc');
saveas(hfigs_states(1), ['../imgs/states', num2str(1)], 'epsc'); 
saveas(hfigs_speeds(1), ['../imgs/speeds', num2str(1)], 'epsc'); 

