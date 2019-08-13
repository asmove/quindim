function hfig = plot_constraints(sys, time, states)
    [m, ~] = size(sys.kin.A);
    
    n_q = length(sys.kin.q);
    
    n_t = length(time);
    unhol = zeros(n_t, 1);
    
    q_s = sys.kin.q';
    qp_s = sys.kin.qp';
    
    [q, qp, p] = states_to_q_qp_p(sys, states);
    
    for i = 1:n_t
        q_n = q(i, :);
        A_num = vpa(subs(sys.kin.A*sys.kin.p, [q_s; p_s], [q; p]));
        unhol(i) = double(A_num);
    end
    
    titles = {};
    xlabels = {};
    Aqp = sys.kin.A*sys.kin.qp;
    
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