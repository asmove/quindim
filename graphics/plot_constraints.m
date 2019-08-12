function hfig = plot_constraints(sys, time, states)
    [m, ~] = size(sys.A);
    
    n_q = length(q_sym);
    
    n_t = length(time);
    unhol = zeros(n_t, 1);
    
    q_sym = sys.q';
    qp_sym = sys.qp';
    q_num = states(:, 1:n_q);
    p_num = states(:, n_q + 1:end);
    
    subs(sys.A*sys.qp, [q_s, p_s], [q_i, p_i]);
    
    for i = 1:n_t
        q_n = q_num(i, :);
        A_num = vpa(subs(sys.A*sys.p, q_sym, q_n));
        unhol(i) = double(A_num);
    end
    
    titles = {};
    xlabels = {};
    Aqp = sys.A*sys.qp;
    
    for i = 1:m
        constraint = latex(Aqp(i));
        titles{end+1} = sprintf('Constraint %d - %s', i, constraint);
        xlabels{end+1} = '$t$ [s]';
    end
    
    plot_info.titles = titles;
    plot_info.xlabels = xlabels;
    plot_info.ylabels = titles;
    plot_info.grid_size = [2, 1];
    
    my_plot(time, plot_info);
end