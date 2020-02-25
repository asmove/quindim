function [hfigs, axs] = my_plot(t, x, plot_config)
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
        
        j = 1;
        for i = 1:length(pos_uniques)
            idx_uniques = find(pos_uniques(i) == pos_multiplots);            
            len_i_multiplots = length(idx_uniques);
            
            legends_j = legends{j};
            markers_j = markers{j};
            
            if(iscell(legends{j}))
                len_legends = length(legends{j});
            else
                len_legends = length(legends);
            end
            
            if(iscell(markers{j}))
                len_markers = length(markers{j});
            else
                len_markers = length(markers);
            end
                        
            if(len_i_multiplots + 1 ~= len_legends)
                regex_msg = 'Legends pos %d: Repeated ids : %d; Len legends: %d';
                msg = sprintf(regex_msg, i, len_i_multiplots + 1, ...
                              len_legends);
                error(msg);
            end

            if(len_i_multiplots + 1 ~= len_markers)
                regex_msg = 'Markers pos %d: Repeated ids : %d; Len markers: %d';
                msg = sprintf(regex_msg, i, ...
                              len_i_multiplots + 1, ...
                              len_markers);
                error(msg);
            end
            
            j = j + 1;
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
        msg = ['One recommends the maximum number of ', ...
               num2str(MAX_COLS_DIV)];
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
    
    axs = {};
    while(i <= n_windows)
        hfig = my_figure();
        
        is_multiplot = false;
        axis_i = {};
        for j = 1:nrows*ncols
            id_plot = ind2sub([nrows, ncols], j);
            axis_ij = subplot(nrows, ncols, id_plot);
            axis_i{end+1} = axis_ij;
            
            idx = (i-1)*nrows*ncols + j;
            
            % Main plots
            hold on;
            
            % Subplots
            if(is_subplotable)
                multiplot_idxs = find(pos_multiplots == idx);
                is_multiplot = ~isempty(multiplot_idxs);
                
                if(is_multiplot)
                    if(iscell(legends{j}))
                        legends_j = legends{h};
                        markers_j = markers{h};
                    else
                        legends_j = legends;
                        markers_j = markers;
                    end
                    
                    markers_f = markers_j{f};
                    legends_f = legends_j{f};
                    
                    head_x = double(head_x);
                    if(~isfield(plot_config, 'plot_type'))
                        plot(t, head_x(:, idx), markers_f);
                    else
                        plot_func = str2func(plot_config.plot_type);
                        plot_func(t, head_x(:, idx), markers_f);
                    end
                    
                    hold on;
                    f = f + 1;
                    
                    for multiplot_idx = multiplot_idxs
                        markers_f = markers_j{f};
                        legends_f = legends_j{f};
                        
                        markers_f
                        legends_f
                        tail_x(:, multiplot_idx)
                        
                        if(~isfield(plot_config, 'plot_type'))
                            plot(t, tail_x(:, multiplot_idx), markers_f);
                        else
                            plot_func = str2func(plot_config.plot_type);
                            plot_func(t, tail_x(:, multiplot_idx), ...
                                      markers_f);
                        end
                        
                        hold on;
                        f = f + 1;
                    end
                    
                    legend(legends_j, 'interpreter', 'latex');
                    
                    hold off;

                    f = 1;
                    h = h + 1;
                    multiplot = false;
                else
                    if(~isfield(plot_config, 'plot_type'))
                        plot(t, head_x(:, idx), markers_f);
                    else
                        plot_func = str2func(plot_config.plot_type);
                        plot_func(t, head_x(:, idx), markers_f);
                    end
                end
            else
                if(~isfield(plot_config, 'plot_type'))
                    plot(t, head_x(:, idx));
                else
                    plot_func = str2func(plot_config.plot_type);
                    plot_func(t, head_x(:, idx));
                end
            end
            
            title(titles{idx}, 'interpreter', 'latex');
            xlabel(xlabels{idx}, 'interpreter', 'latex');
            ylabel(ylabels{idx}, 'interpreter', 'latex');
            grid;
        end
        
        axs{end+1} = axis_i;
        
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
        
        axis_k = {};
        for k = 1:remaind_n
            id_plot = ind2sub([new_nrows, new_ncols], k);
            
            % HARDCODE: Plot in case of 7 or 11 remainder plots
            if((remaind_n == 7) && (k == 7))
                id_plot = [7, 8];
            elseif((remaind_n == 11) && (k == 11))
                id_plot = [7, 8];
            end

            axis_ik = subplot(new_ncols, new_nrows, id_plot);
            
            axis_k{end+1} = axis_ik;
            
            plot(t, xs(:, k));

            title(titles{k+i-1}, 'interpreter', 'latex');
            xlabel(xlabels{k+i-1}, 'interpreter', 'latex');
            ylabel(ylabels{k+i-1}, 'interpreter', 'latex');
            grid;
            
            k = k+1;
        end
        
        axs{end+1} = axis_k;
    end
end
