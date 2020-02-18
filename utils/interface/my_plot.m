function hfigs = my_plot(t, x, plot_config)
    MAX_ROWS_DIV = 4;
    MAX_COLS_DIV = 4;
    
    [m, n] = size(x);
    
    hfigs = [];
    
    titles = plot_config.titles;
    xlabels = plot_config.xlabels;
    ylabels = plot_config.ylabels;
    nrows = plot_config.grid_size(1);
    ncols = plot_config.grid_size(2);
    
    % Find out subplot properties and evoke error or warning when necessary
    is_subplotable = iscell(x);
    if(is_subplotable)
        legends = plot_config.legends;
        pos_multiplots = plot_config.pos_multiplots;
        markers = plot_config.markers;
        
        pos_uniques = unique(plot_config.pos_multiplots);
        len_legends = length(pos_uniques);
        
        for i = 1:length(pos_uniques)
            idx_uniques = find(pos_uniques(i) == pos_multiplots);
            len_i_multiplots = length(idx_uniques);
            
            if(iscell(legends))
                len_legends = length(legends);
            else
                len_legends = length(legends(i));
            end
            
            if(iscell(markers))
                len_markers = length(markers);
            else
                len_markers = length(markers(i));
            end
            
            if(len_i_multiplots + 1 ~= len_legends)
                regex_msg = 'Legends pos %d: Repeated ids : %d; Len legends: %d';
                msg = sprintf(regex_msg, i, len_i_multiplots + 1, len_legends);
                error(msg);
            end

            if(len_i_multiplots + 1 ~= len_markers)
                regex_msg = 'Markers pos %d: Repeated ids : %d; Len markers: %d';
                msg = sprintf(regex_msg, i, len_i_multiplots + 1, len_markers);
                error(msg);
            end
        end
        
        head_x = x{1};
        tail_x = x{2};
        
        x_main = head_x;
        x_multi = tail_x;
        
        if(~issorted(pos_multiplots))
            msg = 'Please, the data for subplots must be in a sorted format';
            error(msg);
        end
    else
        head_x = x;
    end
    
    
    if((nrows >= MAX_ROWS_DIV) || (ncols >= MAX_COLS_DIV))
        msg = ['One recommends the maximum number of ', MAX_COLS_DIV];
        warning(msg);
    end
    
    if(is_subplotable)
        [~, n] = size(x{1});
    else
        [~, n] = size(x);
    end
    
    n_subplots = nrows*ncols;

    remaind_n = rem(n, n_subplots);
    n_windows = (n - remaind_n)/n_subplots;
    
    h_legends = {};

    % Current position on markers and legends blobs
    f = 1;
    
    % Current position on multiplots
    g = 1;
    
    % Current position on legends and markers
    h = 1;
    
    % Current position on windows
    i = 1;
    
    % Current position on data plots
    k = 1;
    
    is_first = true;
    while(i <= n_windows)
        hfig = my_figure();
        
        is_multiplot = false;
        for j = 1:nrows*ncols
            id_plot = ind2sub([nrows, ncols], j);
            
            idx = (i-1)*nrows*ncols + j;

            h_subplot = subplot(nrows, ncols, id_plot);
            
            plot(t, head_x(:, idx));
            title(titles{idx}, 'interpreter', 'latex');
            xlabel(xlabels{idx}, 'interpreter', 'latex');
            ylabel(ylabels{idx}, 'interpreter', 'latex');
            grid;
            
            if(is_subplotable)
                is_multiplot = ~isempty(find(pos_multiplots == idx));

                if(is_multiplot)
                    if(g <= length(pos_multiplots))    
                        if(pos_multiplots(g) == k)
                            if(iscell(legends))
                                legends_i = legends;
                            else
                                legends_i = legends(f);
                            end

                            if(is_first)
                                h_legends{end + 1} = legends_i{1};
                                is_first = false;
                                h = h+1;
                            end

                            h_legends{end + 1} = legends_i{h};

                            hold on;
                            
                            plot(t, tail_x(:, f+h-2), markers{h});
                            
                            f = f+1;
                            g = g+1;
                            h = h+1;
                        end
                    end

                    if(h > length(pos_multiplots))
                        hold off;

                        legend(h_legends, 'interpreter', 'latex');
                        is_multiplot = false;
                        h_legends = {};

                        f = 1;
                        h = 1;

                    elseif(pos_multiplots(h) ~= k)
                        hold off;

                        legend(h_legends);
                        is_multiplot = false;
                        h_legends = {};

                        f = 1;
                        h = 1;

                        multiplot = false;
                        
                        % Tight borders for better saving
                        ax = gca;
                        outerpos = ax.OuterPosition;
                        ti = ax.TightInset; 
                        left = outerpos(1) + ti(1);
                        bottom = outerpos(2) + ti(2);
                        ax_width = outerpos(3) - ti(1) - ti(3);
                        ax_height = outerpos(4) - ti(2) - ti(4);
                        ax.Position = [left bottom ax_width ax_height];
                    end
                end
            end
            
            k = k+1;
        end

        hfigs = [hfigs; hfig];
        i = i + 1;
    end

    % Unelegant but efficient way to divide the plot window
    % Hypothesis: Maximum of 12 windows
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
            
            k = k+1;
        end    
    end
end

