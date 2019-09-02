function expr_sup = func_minmax(expr, x, is_min, label)
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
    expr_sup = sym(0);
    for i = 1:length(exprs)
        expr_ = exprs(i);
        monomes = strsplit(char(expr_), '*');

        expr_sym = sym(1);
        expr_x = sym(1);
        
        for monome = monomes
            monome_sym = sym(monome);
            monome_vars = symvar(monome_sym);

            is_not_x = ~all(ismember(monome_vars, x));

            if(is_not_x || isempty(monome_vars))
                expr_sym = sym(expr_sym*monome);
            else
                for bounded_func = bounded_funcs
                    if(all(ismember(char(bounded_func), char(monome))))
                        if(is_min)
                            monome_sym = sym(0);
                        else
                            monome_sym = sym(1);
                        end
                    end
                end

                expr_x = sym(expr_x*monome_sym);
            end
        end
        
        expr_i_sup = abs(sym(expr_sym)*sym(expr_x));
        expr_sup = expr_sup + expr_i_sup;
        
        wb_outer = wb_outer.update_waitbar(i, length(exprs));
    end
    
    wb_outer.close_window();
end