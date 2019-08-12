function [hfigs_states, ...
          hfig_energies] = plot_sysprops(sys, time, states, plot_info)
    hfigs_states = my_plot(time, states, plot_info);
    hfig_energies = plot_energies(sys, time, states);
end