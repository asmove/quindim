% Generalized coordinates
plot_info_q.titles = repeat_str('', 4);
plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$'};
plot_info_q.grid_size = [2, 2];

hfigs_states = my_plot(tspan, x(:, 1:4), plot_info_q);

plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = {'$t$ [s]', '$t$ [s]'};
plot_info_p.ylabels = {'$p_1$', '$p_2$'};
plot_info_p.grid_size = [2, 1];

% States plot
hfigs_speeds = my_plot(tspan, x(:, 5:end), plot_info_p);

% Energies plot
hfig_energies = plot_energies(sys, tspan, x);
hfig_consts = plot_constraints(sys, tspan, x);

% Images
saveas(hfig_energies, '../images/energies', 'epsc');
saveas(hfigs_states(1), ['../images/states', num2str(1)], 'epsc'); 
saveas(hfigs_speeds(1), ['../images/speeds', num2str(1)], 'epsc'); 
saveas(hfig_consts(1), ['../images/consts', num2str(1)], 'epsc'); 
