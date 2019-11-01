function result = triang_ineq(expr, x, label, symbs, params_eval, is_min)
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
        
        for monome = monomes
            if(contains(monome, '(') || contains(monome, ')'))
                continue;
            else
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
                            if(is_min)
                                expr_x = sym(0);
                                break;
                            else
                                expr_x = expr_x*sym(1);
                            end
                        end
                    end
                end 
            end
            
        end
        
        expr_i_sup = abs(sym(expr_sym)*sym(expr_x));
        
        result = result + expr_i_sup;
        
        wb_outer = wb_outer.update_waitbar(i, length(exprs));
    end
    
    result = subs(result, symbs, params_eval);    
    wb_outer.close_window();
end
