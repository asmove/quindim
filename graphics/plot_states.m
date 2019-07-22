function plot_states(t, x, titles, xlabels, ylabels)
    [~, n] = size(x);
    
    num_subplots = 4;
    remaind_n = rem(n, num_subplots);
    n_windows = (n - remaind_n)/num_subplots;
    
    i = 1;
    while(i < n_windows)
        hfig = my_figure();
        
        subplot(2, 2, 1);
        plot(t, x(:, i));
        title(titles{i});
        xlabel(xlabels{i});
        ylabel(ylabels{i});
        
        subplot(2, 2, 2);
        plot(t, x(:, i+1));
        title(titles{i+1});
        xlabel(xlabels{i+1});
        ylabel(ylabels{i+1});
        
        subplot(2, 2, 3);
        plot(t, x(:, i+2));
        title(titles{i+2});
        xlabel(xlabels{i+2});
        ylabel(ylabels{i+2});
        
        subplot(2, 2, 4);
        plot(t, x(:, i+3));
        title(titles{i+3});
        xlabel(xlabels{i+3});
        ylabel(ylabels{i+3});
        
        i = i + num_subplots;
    end
    
    % Plot 
    hfig = my_figure();
    xs = x(:, n_windows*num_subplots+1:end);

    for k = 1:remaind_n
        subplot(n, 1, k);
        plot(t, xs(:, k));
        
        title(titles{i-1+k}, 'interpreter', 'latex');
        xlabel(xlabels{i-1+k}, 'interpreter', 'latex');
        ylabel(ylabels{i-1+k}, 'interpreter', 'latex');
    end    
end
