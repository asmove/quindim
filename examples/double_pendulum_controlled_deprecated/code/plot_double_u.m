function plot_double_u(u_lin, u_nlin, to, fname)
    hfig = figure('units','normalized', ...
                  'outerposition', [0 0 1 1], ...
                  'PaperPositionMode', 'auto');

    stairs(u_lin.time, u_lin.signals.values);
    hold on;
    stairs(u_nlin.time, u_nlin.signals.values);
    hold off;
    
    ylim([-1.5, 1.5])

    title('$u(t)$', 'interpreter', 'latex');
    legend({'u(t) - Linear', 'u(t) - Nonlinear'}, ...
            'interpreter', 'latex', '-r0');

    print(hfig, [to, fname], '-depsc2', '-r0');
end