function hfig = plot_double_xxhat(w, x_lin, x_nlin, xhat, to, fname)
    hfig = figure('units','normalized', ...
                  'outerposition',[0 0 1 1], ...
                  'PaperPositionMode', 'auto');

    subplot(3, 2, 1);
    plot(x_lin.time, x_lin.signals.values(:, 1), 'b');
    hold on;
    plot(x_nlin.time, x_nlin.signals.values(:, 1), 'r');
    hold on;
    plot(xhat.time, xhat.signals.values(:, 1), 'k');
    hold on;
    plot(w.time, w.signals.values, 'g--');
    hold off
    
    title('$x(t)$', 'interpreter', 'latex')
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[m]', 'Interpreter', 'latex');
    hleg = legend({'$x$ - Linear', '$x$ - Nonlinear', ...
                   '$\hat{x}$', '$w$'}, ...
                   'Location','best','Interpreter','latex');
    
    subplot(3, 2, 2);
    plot(x_lin.time, x_lin.signals.values(:, 4), 'b');
    hold on;
    plot(x_nlin.time, x_nlin.signals.values(:, 4), 'r');
    hold on;
    plot(xhat.time, xhat.signals.values(:, 4), 'k');
    hold off
    
    title('$\dot x(t)$', 'interpreter', 'latex')
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[m/s]', 'Interpreter', 'latex');
    legend({'$\dot x - Linear$', '$x$ - Nonlinear', '$\hat{\dot x}$'}, ...
           'Location','best','Interpreter','latex');    
    
    subplot(3, 2, 3);
    plot(x_lin.time, x_lin.signals.values(:, 2), 'b');
    hold on;
    plot(x_nlin.time, x_nlin.signals.values(:, 2), 'r');
    hold on;
    plot(xhat.time, xhat.signals.values(:, 2), 'k');
    hold off
    
    title('$\theta_1(t)$', 'interpreter', 'latex')
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[rad]', 'Interpreter', 'latex');
    legend({'$\theta_1$ - Linear', '$\theta_1$ -  Nonlinear', '$\hat{\theta_1}$'}, ...
           'Location','best','Interpreter','latex');
    
    subplot(3, 2, 4);
    plot(x_lin.time, x_lin.signals.values(:, 5), 'b');
    hold on;
    plot(x_nlin.time, x_nlin.signals.values(:, 5), 'r');
    hold on;
    plot(xhat.time, xhat.signals.values(:, 5), 'k');
    hold off
    
    title('$\dot \theta_1(t)$', 'interpreter', 'latex')
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[rad/s]', 'Interpreter', 'latex');
    legend({'${\dot \theta}_1$ - Linear', '${\dot \theta}_1$ -  Nonlinear', ...
            '$\hat{\dot \theta}_1$'}, ...
            'Location','best','Interpreter','latex');
    
    subplot(3, 2, 5);
    plot(x_lin.time, x_lin.signals.values(:, 3), 'b');
    hold on;
    plot(x_nlin.time, x_nlin.signals.values(:, 3), 'r');
    hold on;
    plot(xhat.time, xhat.signals.values(:, 3), 'k');
    hold off;
    
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[rad/s]', 'Interpreter', 'latex');
    legend({'$\theta_2$ - Linear', '$\theta_2$ - Nonlinear', ...
           '$\hat{\theta}_2$'}, 'Location','best','Interpreter','latex');
    
    title('$\theta_2(t)$', 'interpreter', 'latex')
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[rad]', 'Interpreter', 'latex');
    
    subplot(3, 2, 6);
    plot(x_lin.time, x_lin.signals.values(:, 6), 'b');
    hold on;
    plot(x_nlin.time, x_nlin.signals.values(:, 6), 'r');
    hold on;
    plot(xhat.time, xhat.signals.values(:, 6), 'k');
    hold off;
    
    title('$\dot \theta_2(t)$', 'interpreter', 'latex')
    xlabel('[s]', 'Interpreter', 'latex');
    ylabel('[rad/s]', 'Interpreter', 'latex');
    legend({'${\dot \theta}_2$ - Linear', '${\dot \theta}_2$ - Nonlinear', ...
            '$\hat{\dot \theta}_2$'}, 'Location','best','Interpreter','latex');
    
    print(hfig, [to, fname], '-depsc', '-r0');
end
