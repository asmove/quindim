function result = triang_ineq(expr, x, label, symbs, params_eval)
    expr = expand(expr);
    expr_strip = strsplit(char(expr));
    
    i = 1:length(expr_strip);

    exprs = expr_strip(mod(i, 2) ~= 0);
    bounded_funcs = {'sin', 'cos'};
    
    if(is_min)
        goal = 'Minoration'; 
    else
        goal = 'Majoration';
    end
    
    wb_outer = my_waitbar([label, ' - ', goal]);
    
    % Numerator expression
    result = sym(0);
    for i = 1:length(exprs)
        expr_ = exprs(i);
        monomes = strsplit(char(expr_), '*');
        
        expr_sym = sym(1);
        expr_x = sym(1);
        
        n_monomes = length(monomes);
        
        must_jump = false;
        for j = 1:n_monomes
            if(must_jump)
                must_jump = false;
                continue;
            end
            
            monome = monomes{j};

            for bounded_func = bounded_funcs
                has_left_parenthesis = ~isempty(findstr(char('('), ...
                                                        char(monome)));
                has_right_parenthesis = ~isempty(findstr(char(')'), ...
                                                        char(monome)));
                                                    
                has_sin_cos = ~isempty(findstr(char(bounded_func), ...
                                                 char(monome)));
                if(has_sin_cos && ...
                   has_left_parenthesis && ... 
                   ~has_right_parenthesis)
                    
                    monome = [monome, '*', monomes{j+1}];
                    
                    must_jump = true;
                    break;
                end
            end
            
            monome_sym = sym(monome);
            monome_vars = symvar(monome_sym);

            is_not_x = ~all(ismember(monome_vars, x));

            % Parameters of the plant
            if(is_not_x || isempty(monome_vars))
                expr_sym = sym(expr_sym)*sym(monome);

            else
                % States of the system
                for bounded_func = bounded_funcs
                    is_bounded = ismember(char(bounded_func), char(monome));

                    if(all(is_bounded))
                        expr_x = expr_x*sym(1);
                    end
                end
            end
        end
        
        expr_i_sup = abs(sym(expr_sym)*sym(expr_x));
        
        result = result + expr_i_sup;
        wb_outer.update_waitbar(i, length(exprs));
    end
    
    result = subs(result, symbs, params_eval);    
    wb_outer.close_window();
end
