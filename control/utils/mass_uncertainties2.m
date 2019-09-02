function [D, D_tilde] = mass_uncertainties2(Ms, Ms_hat, x, ...
                                           params_syms, params_hat_syms, ...
                                           params_lims)
    
    n = length(Ms);
    
    % Initialization
    D = sym(zeros(n));
    D_tilde = sym(zeros(n));
    
    % Symbolic terms
    params_s = [params_syms; params_hat_syms];
    
    % Parameter boundaries
    params_min = params_lims(:, 1);
    params_n_min = [params_min; params_min];
    
    params_max = params_lims(:, 2);
    params_n_max = [params_max; params_max];
    
    sup_Ms = sym(zeros(n, n));
    for i = 1:n
        for j = 1:n
            m_s = Ms(i, j);
            
            ms_sup = func_minmax(m_s, x, 0);
            ms_sup = subs(ms_sup, params_s, params_n_max);
            
            sup_Ms(i, j) = abs(ms_sup);
        end
    end
    
    adj_Ms_hat = adjoint(Ms_hat);
    sup_adj_Ms = sym(zeros(n, n));
    for i = 1:n
        for j = 1:n
            adj_m_s = adj_Ms_hat(i, j);
            
            ms_sup = func_minmax(adj_m_s, x, 0);
            ms_sup = subs(ms_sup, params_s, params_n_max);
            
            sup_adj_Ms(i, j) = abs(ms_sup);
        end
    end

    % Numerator and denominator for D matrix
    inf_det_Ms_hat = func_minmax(det(Ms_hat), x, 1);
    inf_det_Ms_hat = subs(inf_det_Ms_hat, params_s, params_n_min);
    
    num_sup = sup_Ms*sup_adj_Ms;
    den_inf = inf_det_Ms_hat;
    
    for i = 1:n
        for i = 1:n
            if i == j
                d_ij = (num_sup - den_inf)/den_inf;
            else
                d_ij = num_sup/den_inf;
            end

            D(i, j) = d_ij;

            if i == j
                D_tilde(i, j) = d_ij;
            else
                D_tilde(i, j) = -d_ij;
            end    
        end
    end
end