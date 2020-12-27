plot_info.titles = {};
plot_info.xlabels = {};
plot_info.ylabels = {};

for i = 1:n_mbk
    q_i = sys.kin.q(i);
    idx1 = 2*i - 1;
    idx2 = 2*i;
    
    plot_info.titles{idx1} = '';
    plot_info.titles{idx2} = '';
    plot_info.xlabels{idx1} = '$t$ [s]';
    plot_info.xlabels{idx2} = '$t$ [s]';
    plot_info.ylabels{idx1} = ['$', char(q_i),'$ $[m]$'];
    plot_info.ylabels{idx2} = ['$\dot ', char(q_i),'$ $[\frac{m}{s}]$'];
end

plot_info.grid_size = [min(n_mbk, 5), 2];

% States plot
hfigs_states = my_plot(t, x, plot_info);

% Energies plot
hfig_energies = plot_energies(sys, t, x);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');

for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../imgs/states', num2str(i)], 'epsc'); 
end
