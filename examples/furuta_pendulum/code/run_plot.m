plot_info.titles = {'$\theta_0$', '$\theta_1$', ...
                    '$\dot \theta_0$', '$\dot \theta_1$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$\theta_0$', '$\theta_1$', ...
                    '$\dot \theta_0$', '$\dot \theta_1$'};
plot_info.grid_size = [2, 2];

% States and energies plot
hfigs_states = my_plot(t, x, plot_info);
hfig_energies = plot_energies(sys, t, x);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');

for j = 1:length(hfigs_states)
   saveas(hfigs_states(j), ['../imgs/states', num2str(i)], 'epsc'); 
end
