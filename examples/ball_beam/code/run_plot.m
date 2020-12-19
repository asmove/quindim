% Generalized coordinates
plot_info_q.titles = {'', '', ''};
plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info_q.ylabels = {'$\phi$', '$\theta$', '$r$'};
plot_info_q.grid_size = [3, 1];

hfigs_states = my_plot(t, x(:, 1:3), plot_info_q);

plot_info_p.titles = {'', ''};
plot_info_p.xlabels = {'$t$ [s]', '$t$ [s]'};
plot_info_p.ylabels = {'$\omega_{\phi}$', '$\omega_{\theta}$'};
plot_info_p.grid_size = [2, 1];

% States plot
hfigs_speeds = my_plot(t, x(:, 4:5), plot_info_p);

% Energies plot
hfig_consts = plot_constraints(sys, t, x);
hfig_energies = plot_energies(sys, t, x);

% Images
for i = 1:length(hfig_energies)
    saveas(hfig_energies, ['../imgs/energies_', num2str(i)], 'epsc');
end

for i = 1:length(hfigs_speeds) 
    saveas(hfigs_speeds, ['../imgs/speeds_', num2str(i)], 'epsc'); 
end

for i = 1:length(hfigs_states) 
    saveas(hfigs_states, ['../imgs/states_', num2str(i)], 'epsc'); 
end
    
for i = 1:length(hfig_consts) 
    saveas(hfig_consts, ['../imgs/consts_', num2str(i)], 'epsc'); 
end

