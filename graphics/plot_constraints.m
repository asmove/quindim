function hfig = plot_constraints(sys, time, states)
    [m, ~] = size(sys.kin.A);
    
    n_q = length(sys.kin.q);
    
    n_t = length(time);
    unhol = zeros(n_t, n_p);
    
    q_s = sys.kin.q;
    qp_s = sys.kin.qp;
    
    syms = sys.descrip.syms;
    model_params = sys.descrip.model_params;
    
    [q, qp, p] = states_to_q_qp_p(sys, states);
    
    Aqps = sym([]);
    p_n_curr = p';
    
    n_As = 0;
    for i = 1:length(sys.kin.A)
        [n_Ai, ~] = size(sys.kin.A{i});
        n_As = n_As + n_Ai;
    end
    
    unhol = zeros(n_t, n_As);
    
    n_p = length(sys.kin.p);
    
    As = sys.kin.A;
    
    for i = 1:length(As)
        A_i = As{i};
        p_i = sys.kin.p{i};
        
        [n_conts, n_p] = size(A_i);
        
        for j = 1:n_conts
            [n_pi, ~] = size(A_i);
                        
            C = sys.kin.C{j};
            
            Aqps = [Aqps; A_i*p_i];
            
            for k = 1:n_pi
                for i = 1:n_t
                    q_n = q(i, :);
                    
                    p_n = vpa(subs(C*p_n_curr, ...
                              [q_s', syms], ...
                              [q_n, model_params]));
                    
                    qp_pars_s = [q_s; p_s_curr; syms.'];
                    qp_pars_n = [q_n'; p_n(:, i); model_params'];
                    
                    consts = vpa(subs(A_curr*p_s_curr, ...
                        qp_pars_s, qp_pars_n));
                    
                    unhol(i, j+k-1) = double(consts(k));
                end
            end
            
            p_n_curr = vpa(subs(C*p_n_curr, syms, model_params));
        end
    end
        
    titles = {};
    xlabels = {};
    
    acc = 0;
    for i = 1:n_p 
        [m, ~] = size(sys.kin.A{j});
        
        for j = 1:m
            idx = acc + j;
            
            constraint = latex(Aqps(idx));
            
            titles{end+1} = sprintf('Constraint %d - $%s$', ...
                                    idx, constraint);
            xlabels{end+1} = '$t$ [s]';
        end
        
        acc = acc + m;
    end
        
    plot_info.titles = titles;
    plot_info.xlabels = xlabels;
    plot_info.ylabels = titles;
    plot_info.grid_size = [2, 1];
    
    hfig = my_plot(time, unhol, plot_info);
end