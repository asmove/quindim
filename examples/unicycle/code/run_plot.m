% Generalized coordinates
plot_info_q.titles = repeat_str('', 3);
plot_info_q.xlabels = repeat_str('$t$ [s]', 3);
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$'};
plot_info_q.grid_size = [3, 1];

hfigs_states = my_plot(tspan, x(:, 1:3), plot_info_q);

% Generalized coordinates
plot_info_q.titles = repeat_str('', 2);
plot_info_q.xlabels = repeat_str('$t$ [s]', 2);
plot_info_q.ylabels = {'$\phi_1$', '$\phi_2$'};
plot_info_q.grid_size = [2, 1];

hfigs_states = my_plot(tspan, x(:, 4:5), plot_info_q);

plot_info_p.titles = repeat_str('', length(sys.kin.p{end}));
plot_info_p.xlabels = repeat_str('$t [s]$', length(sys.kin.p{end}));
plot_info_p.ylabels = {'$\omega_{\theta}$', '$p_2$', ...
                      '$\omega_{\phi_1}$', '$\omega_{\phi_2}$'};
plot_info_p.grid_size = [2, 2];

% States plot
hfigs_speeds = my_plot(tspan, p, plot_info_p);

% Energies plot
hfig_energies = plot_energies(sys, tspan, x);
hfig_consts = plot_constraints(sys, tspan, x);

% Images
saveas(hfig_energies, '../images/energies', 'epsc');
saveas(hfigs_states(1), ['../images/states', num2str(1)], 'epsc'); 
saveas(hfigs_speeds(1), ['../images/speeds', num2str(1)], 'epsc'); 
saveas(hfig_consts(1), ['../images/consts', num2str(1)], 'epsc'); 
