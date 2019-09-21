function [D, I_m_tilde, Ms_hat] = mass_uncertainties(Ms, q_p, params_syms, params_lims)
    
    n = length(Ms);
    
    % Parameter boundaries
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);
    
    Ms_min = subs(Ms, params_syms, params_min);
    Ms_max = subs(Ms, params_syms, params_max);
    
    % inv(Mu) = I + inv(Ms_hat)
    % Mu = I + Ms_hat
    Mu = Ms_max/Ms_min;
    Mu_1 = inv(Mu);
    Ms_hat = sqrt(Ms_max*Ms_min);
    
    D_Mu_sq = supinf_matrix(Mu, q_p, params_syms, params_lims, 0);
    D_Mu_1_sq = supinf_matrix(Mu_1, q_p, params_syms, params_lims, 0);

    D_Mu = abs(-eye(n) + sqrt(D_Mu_sq));
    D_Mu_1 = abs(-eye(n) + sqrt(D_Mu_1_sq));

    D_Mu = double(D_Mu);
    D_Mu_1 = double(D_Mu_1);

    for i = 1:n
        for j = 1:n
            if(D_Mu(i, j) > D_Mu_1(i, j))
                D(i, j) = D_Mu(i, j);
            else
                D(i, j) = D_Mu_1(i, j);
            end
        end
    end
    
    I_m_tilde = abs(eye(n) - D);
    
end

function D = supinf_matrix(matrix, q_p, params_syms, params_lims, is_min)
    % Parameter limits
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);
    
    n = length(matrix);
    
    % Initialization
    D = sym(zeros(n));
    
    for i = 1:n
        for j = 1:n
            a_ij = matrix(i, j);

            [num, den] = numden(expand(a_ij));
            
            label = sprintf('(%d, %d)', i, j);
            
            % Numerator and denominator for D matriq_p
            maj_num = abs_func_maj(num, q_p, label);
            maj_num = vpa(subs(maj_num, params_syms, params_max));
            
            min_den = abs_func_min(den, q_p, is_min, label);
            min_den = vpa(subs(min_den, params_syms, params_min));
            
            D(i, j) = maj_num/min_den;
        end
    end
end