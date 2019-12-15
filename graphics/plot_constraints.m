function hfig = plot_constraints(sys, time, states)
    [m, ~] = size(sys.kin.A);
    
    n_q = length(sys.kin.q);
    n_p = length(sys.kin.p{end});
    
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
    
    acc = 0;
    % Each constraint line
    for i = 1:length(As)
        A_s = As{i};
        
        if(i == 1)
            p_s = sys.kin.qp;
        else
            p_s = sys.kin.p{i};
        end
        
        [n_const, n_p] = size(A_s);
        
        % Each constraint line
        for j = 1:n_const
            [n_pi, ~] = size(A_s);
            
            C = collapse_C(sys);
                        
            Aqps = [Aqps; A_s*p_s];
            
            % States and speeds timewise
            q_n = states(:, 1:n_q)';
            
            for k = 1:n_t
                q_i = q_n(:, k);  
                p_n = vpa(subs(C*p_n_curr, [q_s', syms], [q_i', model_params]));
            end
            
            % Each time instant
            for k = 1:n_t
                p_i = p_n(:, i);
                q_i = q_n(:, i);

                qp_pars_s = [q_s; p_s; syms.'];
                qp_pars_n = [q_i; p_i; model_params'];

                consts = vpa(subs(A_s*p_s, qp_pars_s, qp_pars_n));

                unhol(i, acc + j) = double(consts(j));
            end
        end
        
        acc = acc + n_const;
    end
        
    consts_label = {};
    xlabels = {};
    
    acc = 0;
    for i = 1:length(sys.kin.As)
        
        [m, ~] = size(sys.kin.A{i});
        
        for j = 1:m
            idx = acc + j;
            
            constraint = latex(Aqps(idx));
            
            consts_label{end+1} = sprintf('Constraint %d - $%s$', ...
                                    idx, constraint);
            xlabels{end+1} = '$t$ [s]';
        end
        
        acc = acc + m;
    end
    
    plot_info.titles = repeat_str('', length(consts_label));
    plot_info.xlabels = xlabels;
    plot_info.ylabels = consts_label;
    plot_info.grid_size = [2, 1];
    
    hfig = my_plot(time, unhol, plot_info);
end