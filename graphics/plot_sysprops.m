function [hfigs_states, ...
          hfig_energies, ...
          hfig_consts] = plot_sysprops(sys, time, states, plot_info)
    
    hfigs_states = my_plot(time, states, plot_info);
    hfig_energies = plot_energies(sys, time, states);
    
    if(sys.descrip.is_constrained)
        hfig_consts = plot_constraints(sys, time, states); 
    end
end