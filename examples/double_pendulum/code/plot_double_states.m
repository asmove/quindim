function hfig = plot_double_states(x, to, fname)
    hfig = figure('units','normalized', ...
                  'outerposition',[0 0 1 1], ...
                  'PaperPositionMode', 'auto');

    subplot(3, 2, 1);
    plot(x.time, x.signals.values(:, 1));
    title('$x(t)$', 'interpreter', 'latex')
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[m]', 'Interpreter', 'latex');
    
    subplot(3, 2, 2);
    plot(x.time, x.signals.values(:, 4));
    title('$\dot x(t)$', 'interpreter', 'latex')
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[m/s]', 'Interpreter', 'latex');
    
    subplot(3, 2, 3);
    plot(x.time, x.signals.values(:, 2));
    title('$\theta_1(t)$', 'interpreter', 'latex')
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[rad]', 'Interpreter', 'latex');
    
    subplot(3, 2, 4);
    plot(x.time, x.signals.values(:, 4));

    title('$\dot \theta_1(t)$', 'interpreter', 'latex')
    xlim([min(x.time), max(x.time)]);
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[rad/s]', 'Interpreter', 'latex');
    
    subplot(3, 2, 5);
    plot(x.time, x.signals.values(:, 3));
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[rad/s]', 'Interpreter', 'latex');
    
    title('$\theta_2(t)$', 'interpreter', 'latex')
    xlim([min(x.time), max(x.time)]);
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[rad]', 'Interpreter', 'latex');
    
    subplot(3, 2, 6);
    plot(x.time, x.signals.values(:, 6));

    title('$\dot \theta_2(t)$', 'interpreter', 'latex')
    xlim([min(x.time), max(x.time)]);
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[rad/s]', 'Interpreter', 'latex');
    
    print(hfig, [to, fname], '-depsc2', '-r0');
end
