plot_info.titles = {'$x_1$', '$\dot x_1$', '$x_2$', '$\dot x_2$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$x_1$ $[m]$', '$\dot x_1$ $[m/s]$', ...
                     '$x_2$ $[m]$', '$\dot x_2$ $[m/s]$'};
plot_info.grid_size = [2, 2];

% States and energies plot
hfigs_states = my_plot(t, x, plot_info);
hfig_energies = plot_energies(sys, t, x);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');

for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../imgs/states', num2str(i)], 'epsc'); 
end
