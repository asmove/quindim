function hfigs = my_plot(t, x, plot_config)
    hfigs = [];
    
    titles = plot_config.titles;
    xlabels = plot_config.xlabels;
    ylabels = plot_config.ylabels;
    nrows = plot_config.grid_size(1);
    ncols = plot_config.grid_size(2);
    
    [~, n] = size(x);
    
    n_subplots = nrows*ncols;
    
    remaind_n = rem(n, n_subplots);
    n_windows = (n - remaind_n)/n_subplots;
    
    i = 1;
    while(i <= n_windows)
        hfig = my_figure();
        for j = 1:nrows*ncols
            id_plot = ind2sub([nrows, ncols], j);
            
            idx = i+j-1;
            
            subplot(nrows, ncols, id_plot);
            
            plot(t, x(:, idx));
            
            title(titles{idx});
            xlabel(xlabels{idx});
            ylabel(ylabels{idx});
            grid;
        end
        hfigs = [hfigs; hfig];
        i = i + nrows*ncols;
    end

    % Remainder plots
    if(remaind_n ~= 0)
        xs = x(:, n_windows*n_subplots+1:end);
        hfig = my_figure();
        hfigs = [hfigs; hfig];
    
        for k = 1:remaind_n
            subplot(remaind_n, 1, k);
            plot(t, xs(:, k));

            title(titles{i+k-1});
            xlabel(xlabels{i+k-1});
            ylabel(ylabels{i+k-1});
            grid;
        end    
    end
    

end
