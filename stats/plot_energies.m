function [K, P, F, T] = plot_energies(sys, time, states)    
    n = length(time);

    K = zeros(n, 1);
    P = zeros(n, 1);
    F = zeros(n, 1);
    T = zeros(n, 1);

    for i = 1:n
        K(i) = subs(sys.K, [sys.states.', sys.syms], ...
                           [states(i,:), sys.model_params]);
        P(i) = subs(sys.P, [sys.states.', sys.syms], ...
                           [states(i,:), sys.model_params]);
        F(i) = subs(sys.F, [sys.states.', sys.syms], ...
                           [states(i,:), sys.model_params]);
        T(i) = subs(sys.total_energy, [sys.states.', sys.syms], ...
                                         [states(i,:), sys.model_params]);
    end

    hfig = figure('units', 'normalized', 'outerposition',[0 0 1 1]);

    subplot(4, 1, 1);
    plot(time, K);
    title('$K(t)$', 'interpreter', 'latex')

    subplot(4, 1, 2);
    plot(time, P);
    title('$U(t)$', 'interpreter', 'latex')

    subplot(4, 1, 3);
    plot(time, F);
    title('$F(t)$', 'interpreter', 'latex')

    subplot(4, 1, 4);
    plot(time, T);
    title('$T(t) = K(t) + U(t) - F(t)$', 'interpreter', 'latex')

    xlim([min(time), max(time)])
end