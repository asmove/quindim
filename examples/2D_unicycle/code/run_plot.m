% Generalized coordinates
plot_info_q.titles = repeat_str('', 3);
plot_info_q.xlabels = {'', '', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$'};
plot_info_q.grid_size = [3, 1];

hfigs_states = my_plot(t, x(:, 1:3), plot_info_q);

plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = {'', '$t$ [s]'};
plot_info_p.ylabels = {'$v$', '$\omega$'};
plot_info_p.grid_size = [2, 1];

% States plot
hfigs_speeds = my_plot(t, x(:, 4:5), plot_info_p);

% Energies plot
hfig_energies = plot_energies(sys, t, x);
hfig_consts = plot_constraints(sys, t, x);

% Images
saveas(hfig_energies, '../imgs/energies', 'epsc');
saveas(hfigs_states(1), ['../imgs/states', num2str(1)], 'epsc'); 
saveas(hfigs_speeds(1), ['../imgs/speeds', num2str(1)], 'epsc'); 
saveas(hfig_consts(1), ['../imgs/consts', num2str(1)], 'epsc'); 
