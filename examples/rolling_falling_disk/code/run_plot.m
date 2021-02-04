% Generalized coordinates
plot_info_q.titles = {'$x$', '$y$', '$\theta$', '$\phi$', '$\psi$'};
plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', ...
                       '$t$ [s]', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$', '$\psi$'};
plot_info_q.grid_size = [2, 2];

hfigs_states = my_plot(x, y(:, 1:4), plot_info_q);

plot_info_p.titles = {'$\omega_{\theta}$', '$\omega_{\phi}$', ...
                      '$\omega_{\psi}$'};
plot_info_p.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info_p.ylabels = {'$\omega_{\theta}$', '$\omega_{\phi}$', ...
                       '$\omega_{\psi}$'};
plot_info_p.grid_size = [3, 1];

% States plot
hfigs_speeds = my_plot(t, x(:, 5:7), plot_info_p);

% Energies plot
hfig_energies = plot_energies(sys, t, x);
hfig_consts = plot_constraints(sys, t, x);

% Images
saveas(hfig_energies, '../images/energies', 'epsc');
saveas(hfigs_states(1), ['../images/states', num2str(1)], 'epsc'); 
saveas(hfigs_speeds(1), ['../images/speeds', num2str(1)], 'epsc'); 
saveas(hfig_consts(1), ['../images/consts', num2str(1)], 'epsc'); 
