function hfigs = my_plot(t, x, plot_config)
    hfigs = [];
    
    titles = plot_config.titles;
    xlabels = plot_config.xlabels;
    ylabels = plot_config.ylabels;
    nrows = plot_config.grid_size(1);
    ncols = plot_config.grid_size(2);
    
    MAX_ROWS_DIV = 4;
    MAX_COLS_DIV = 4;
    
    if((nrows >= MAX_ROWS_DIV) || (ncols >= MAX_COLS_DIV))
        msg = 'One recommends the maximum number of ';
        warning(msg);
    end
        
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
            title(titles{idx}, 'interpreter', 'latex');
            xlabel(xlabels{idx}, 'interpreter', 'latex');
            ylabel(ylabels{idx}, 'interpreter', 'latex');
            grid;
        end
        hfigs = [hfigs; hfig];
        i = i + nrows*ncols;
    end
    
    % Unelegant but efficient way to divide the plot window
    if(mod(remaind_n, 3) == 0)
        new_ncols = remaind_n/3;
        new_nrows = 3;
    elseif((remaind_n == 2) || (remaind_n == 4))
        new_ncols = remaind_n/2;
        new_nrows = 2;
    elseif((remaind_n == 5) || (remaind_n == 10))
        new_ncols = remaind_n/5;
        new_nrows = 5;
    elseif(remaind_n == 1)
        new_ncols = 1;
        new_nrows = 1;
    elseif(remaind_n == 7)
        new_ncols = 4;
        new_nrows = 2;
    elseif(remaind_n == 11)
        new_ncols = 6;
        new_nrows = 2;
    end
    
    % Remainder plots
    if(remaind_n ~= 0)
        xs = x(:, n_windows*n_subplots+1:end);
        hfig = my_figure();
        hfigs = [hfigs; hfig];
    
        for k = 1:remaind_n
            id_plot = ind2sub([new_nrows, new_ncols], k);
            
            % HARDCODE: Plot in case of 7 or 11 remainder plots
            if((remaind_n == 7) && (k == 7))
                id_plot = [7, 8];
            elseif((remaind_n == 11) && (k == 11))
                id_plot = [7, 8];
            end
            
            subplot(new_ncols, new_nrows, id_plot);
                
            plot(t, xs(:, k));

            title(titles{k+i-1}, 'interpreter', 'latex');
            xlabel(xlabels{k+i-1}, 'interpreter', 'latex');
            ylabel(ylabels{k+i-1}, 'interpreter', 'latex');
            grid;
        end    
    end
end
