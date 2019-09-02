function [D, D_tilde] = mass_uncertainties(Ms, Ms_hat, x, ...
                                           params_syms, params_hat_syms, ...
                                           params_lims)
    
    n = length(Ms);
    
    Ms_Ms_hat = Ms*inv(Ms_hat);
    
    % Initialization
    D = sym(zeros(n));
    D_tilde = sym(zeros(n));
            
    % Symbolic terms'F calculation'
    params_s = [params_syms; params_hat_syms];
    
    % Parameter boundaries
    params_min = params_lims(:, 1);
    params_n_min = [params_min; params_min];
    
    params_max = params_lims(:, 2);
    params_n_max = [params_max; params_max];
    
    for i = 1:n
        for j = 1:n
            m_s = Ms_Ms_hat(i, j);
            [num, den] = numden(expand(m_s));
            
            label = sprintf('(%d, %d) - d', i, j);
            
            % Numerator and denominator for D matrix
            d_num_sup = func_minmax(num, x, 0, label);
            d_num_sup = subs(d_num_sup, params_s, params_n_max);
            
            d_den_inf = func_minmax(den, x, 1, label);
            d_den_inf = subs(d_den_inf, params_s, params_n_min);
            
            if i == j
                d_ij = (d_num_sup - d_den_inf)/(d_den_inf);
            else
                d_ij = d_num_sup/d_den_inf;
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