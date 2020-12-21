plot_info.titles = {'', '', '', '', '', '', '', '', ''};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$x$', '$y$', '$\theta$', ...
                    '$\theta_1$', '$\theta_2$', '$\theta_3$', ...
                    '$\dot \theta_1$', '$\dot \theta_2$', '$\dot \theta_3$'};
plot_info.grid_size = [3, 3];

% States and energies plot
hfigs_states = my_plot(tspan, x, plot_info);

plot_info.titles = {''};
plot_info.xlabels = {'$x$ [m]'};
plot_info.ylabels = {'$y$ [m]'};
plot_info.grid_size = [1, 1];

% States and energies plot
[hfigs_xy, axs] = my_plot(x(:, 1), x(:, 2), plot_info);

axis square

hfig_energies = plot_energies(sys, tspan, x);
hfig_constraints = plot_constraints(sys, tspan, x);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');

for j = 1:length(hfigs_states)
   saveas(hfigs_states(j), ['../imgs/states', num2str(i)], 'epsc'); 
end
