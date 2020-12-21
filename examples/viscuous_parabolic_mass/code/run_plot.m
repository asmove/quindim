% Plot properties
plot_info.titles = {''};
plot_info.xlabels = {'$x$ [m]'};
plot_info.ylabels = {'$y$ [m]'};
plot_info.grid_size = [1, 1];

my_plot(q(:, 1), q(:, 2), plot_info);

% Plot properties
titles = {'$x$', '$y$', '$\dot x$'};
xlabels = {'', '', '$t$ [s]'};
ylabels = {'$x$  [m]', '$y$  [m]', '$\dot x$ [m/s]'};
grid_size = [3, 1];

plot_info.titles = titles;
plot_info.xlabels = xlabels;
plot_info.ylabels = ylabels;
plot_info.grid_size = grid_size;

[hfigs_states, ...
 hfig_energies, ...
 hfig_consts] = plot_sysprops(sys, tspan, x, plot_info);

% Energies
saveas(hfig_energies, '../imgs/energies.eps', 'epsc');

% States
for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../imgs/states', num2str(i), '.eps'], 'epsc'); 
end

% Energies
saveas(hfig_energies, '../imgs/constraints.eps', 'epsc');
