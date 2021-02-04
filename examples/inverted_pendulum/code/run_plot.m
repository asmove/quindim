plot_info.titles = {'$x$', '$\theta$',  ...
                    '$\dot x$', '$\dot \theta$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$x$', '$\theta$', ...
                    '$\dot x$', '$\dot \theta$'};
plot_info.grid_size = [2, 2];

% States and energies plot
hfigs_states = my_plot(t, x, plot_info);
hfig_energies = plot_energies(sys, t, x);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');
saveas(hfigs_states, '../imgs/states', 'epsc'); 

