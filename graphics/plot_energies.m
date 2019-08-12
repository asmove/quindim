function [hfig, K, P, F, T] = plot_energies(sys, time, states)    
    n = length(time);
    
    sym_zeros = sym(zeros(n, 1));
    
    K = sym_zeros;
    P = sym_zeros;
    F = sym_zeros;
    T = sym_zeros;
    
    sym_states_params = [sys.dyn.states.', sys.syms];
    
    for i = 1:n
        num_states_params = [states(i,:), sys.model_params];
        K(i) = vpa(subs(sys.dyn.K, sym_states_params, num_states_params));
        P(i) = vpa(subs(sys.dyn.P, sym_states_params, num_states_params));
        F(i) = vpa(subs(sys.dyn.F, sym_states_params, num_states_params));
        T(i) = vpa(subs(sys.dyn.total_energy, sym_states_params, ...
                                          num_states_params));
    end

    plot_info.titles = {'$K(t)$', '$U(t)$', '$F(t)$', '$T(t)$'};
    plot_info.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
    plot_info.ylabels = {'$K(t)$', '$U(t)$', '$F(t)$', '$T(t)$'};
    plot_info.grid_size = [2, 2];
    
    energies = [K, P, F, T];
    
    hfig = my_plot(time, energies, plot_info);
end