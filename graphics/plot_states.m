function hfigs = plot_states(t, x, titles, xlabels, ylabels)
    hfigs = [];

    [~, n] = size(x);
    
    num_subplots = 4;
    remaind_n = rem(n, num_subplots);
    n_windows = (n - remaind_n)/num_subplots;
    
    i = 1;
    while(i <= n_windows)
        hfig = my_figure();
        
        hfigs = [hfigs; hfig];
        
        subplot(2, 2, 1);
        plot(t, x(:, i));
        title(titles{i}, 'interpreter', 'latex');
        xlabel(xlabels{i}, 'interpreter', 'latex');
        ylabel(ylabels{i}, 'interpreter', 'latex');
        grid;
        
        subplot(2, 2, 2);
        plot(t, x(:, i+1));
        title(titles{i+1}, 'interpreter', 'latex');
        xlabel(xlabels{i+1}, 'interpreter', 'latex');
        ylabel(ylabels{i+1}, 'interpreter', 'latex');
        grid;
        
        subplot(2, 2, 3);
        plot(t, x(:, i+2));
        title(titles{i+2}, 'interpreter', 'latex');
        xlabel(xlabels{i+2}, 'interpreter', 'latex');
        ylabel(ylabels{i+2}, 'interpreter', 'latex');
        grid;
        
        subplot(2, 2, 4);
        plot(t, x(:, i+3));
        title(titles{i+3}, 'interpreter', 'latex');
        xlabel(xlabels{i+3}, 'interpreter', 'latex');
        ylabel(ylabels{i+3}, 'interpreter', 'latex');
        grid;
        
        i = i + num_subplots;
    end
    
    % Plot 
    xs = x(:, n_windows*num_subplots+1:end);
    if(remaind_n ~= 0)
       hfig = my_figure();
       hfigs = [hfigs; hfig];
    end
    
    for k = 1:remaind_n
        subplot(remaind_n, 1, k);
        plot(t, xs(:, k));
        
        title(titles{i+k-1}, 'interpreter', 'latex');
        xlabel(xlabels{i+k-1}, 'interpreter', 'latex');
        ylabel(ylabels{i+k-1}, 'interpreter', 'latex');
        grid;
    end    
end
