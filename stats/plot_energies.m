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
        
        K(i) = subs(sys.dyn.K, sym_states_params, num_states_params);
        P(i) = subs(sys.dyn.P, sym_states_params, num_states_params);
        F(i) = subs(sys.dyn.F, sym_states_params, num_states_params);
        T(i) = subs(sys.dyn.total_energy, sym_states_params, ...
                                          num_states_params);
    end

    hfig = figure('units', 'normalized', 'outerposition',[0 0 1 1]);

    subplot(4, 1, 1);
    plot(time, K);
    title('$K(t)$', 'interpreter', 'latex')
    grid;
    
    subplot(4, 1, 2);
    plot(time, P);
    title('$U(t)$', 'interpreter', 'latex')
    grid;
    
    subplot(4, 1, 3);
    plot(time, F);
    title('$F(t)$', 'interpreter', 'latex')
    grid;
    
    subplot(4, 1, 4);
    plot(time, T);
    title('$T(t) = K(t) + U(t) - F(t)$', 'interpreter', 'latex')
    grid;
    
    xlim([min(time), max(time)])
end