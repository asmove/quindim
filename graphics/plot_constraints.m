function hfig = plot_constraints(sys, time, states)
    [m, ~] = size(sys.A);
    
    n_t = length(time);
    consts = zeros(m, n_t);
    
    [q, qp, ~] = states_to_q_qp_p(sys, states);
    
    Aqp = sys.A*sys.qp;
    
    for i = 1:n_t
        consts(:, i) = vpa(subs(Aqp, ...
                           [sys.q', sys.qp'], ... 
                           [q(i, :), qp(i, :)]));
    end
    
    consts = consts';
    
    titles = {};
    xlabels = {};
    ylabels = {};
    
    for i = 1:m
        constraint = latex(Aqp(i));
        ylabels{end+1} = sprintf('Constraint %d', i);
        titles{end+1} = sprintf('Constraint %d - $%s$', i, constraint);
        xlabels{end+1} = '$t$ [s]';
    end
    
    plot_info.titles = titles;
    plot_info.xlabels = xlabels;
    plot_info.ylabels = ylabels;
    plot_info.grid_size = [2, 1];
    
    hfig = my_plot(time, consts, plot_info);
end