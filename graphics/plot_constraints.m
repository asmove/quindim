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
    p_n = p';
    
    n_As = 0;
    for i = 1:length(sys.kin.As)
        [n_Ai, ~] = size(sys.kin.As{i});
        n_As = n_As + n_Ai;
    end
    
    unhol = zeros(n_t, n_As);
    
    n_p = length(sys.kin.p);
    
    As = sys.kin.As;
    n_As = length(As);
    
    wb = my_waitbar('Calculating constraints time lapse');
    
    bar_len = 0;
    
    [n_const, n_p] = size(As);
    
    for A = As
        A = A{1};
        [n_const, n_p] = size(A);

        bar_len = bar_len + 2*n_const*n_t;
    end

    acc = 0;
    i_acc = 0;
    % Each constraint line
    for i = n_As:-1:1
        A_s = As{i};
        C = sys.kin.Cs(i);
        C = C{1};
        
        % Previous velocity
        if(i == 1)
            p_s_1 = sys.kin.qp;
        else 
            p_s_1 = sys.kin.p{i-1};
        end
        
        % Current velocity
        p_s = sys.kin.p{i};
        
        [n_const, n_p] = size(A_s);
                
        % Each constraint line
        for j = 1:n_const
            [n_pi, ~] = size(A_s);
            
            Aqps = [Aqps; A_s*p_s_1];
            
            % States and speeds timewise
            q_n = states(:, 1:n_q)';
            p_n_1 = zeros(n_p, n_t);
            
            for k = 1:n_t
                q_i = q_n(:, k);
                p_i = p_n(:, k);
                
                syms_params = [q_s.', p_s.',  syms];
                num_params = [q_i', p_i', model_params];
                
                p_n_1(:, k) = double(subs(C*p_s, ...
                                          syms_params, num_params))';
                
                i_acc = i_acc + 1;
                wb.update_waitbar(i_acc, bar_len);
            end

            % Each time instant
            for k = 1:n_t
                p_n_1_i = p_n_1(:, i);
                q_n_1_i = q_n(:, i);
                
                qp_pars_s = [q_s; p_s_1; syms.'];
                qp_pars_n = [q_n_1_i; p_n_1_i; model_params'];
                
                consts = vpa(subs(A_s*p_s_1, qp_pars_s, qp_pars_n));

                unhol(i, acc + j) = double(consts(j));
            
                i_acc = i_acc + 1;
                wb.update_waitbar(i_acc, bar_len);
            end
        end
        
        p_n = p_n_1;
        acc = acc + n_const;
    end
        
    consts_label = {};
    xlabels = {};
        
    idx = 0;
    for i = 1:length(sys.kin.As)
        
        [m, ~] = size(sys.kin.As{i});
                
        for j = 1:m
            idx = idx + 1;
            
            const = Aqps(idx);
            constraint = latex(const)
            
            latex_origs = sys.descrip.latex_origs;
            latex_convert = sys.descrip.latex_text;
            
            constraint = str2latex(constraint, latex_origs, latex_convert);
            
            if(iscell(constraint))
               constraint = constraint{1}; 
            end
            
            consts_label{end+1} = sprintf('Constraint %d - $%s$', ...
                                    idx, constraint);
            xlabels{end+1} = '$t$ [s]';
        end
    end
    
    plot_info.titles = repeat_str('', length(consts_label));
    plot_info.xlabels = xlabels;
    plot_info.ylabels = consts_label;
    plot_info.grid_size = [2, 1];
    
    hfig = my_plot(time, unhol, plot_info);
end