function [D, Dtilde, Ms_hat] = mass_uncertainties(Ms, q_p, params_syms, params_lims)
    
    n = length(Ms);
    
    % Parameter boundaries
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);
    
    Ms_min = subs(Ms, params_syms, params_min);
    Ms_max = subs(Ms, params_syms, params_max);
    
    % inv(Mu) = I + inv(Ms_hat)
    % Mu = I + Ms_hat
    Mu = Ms_max*Ms_min;
    Mu_1 = inv(Mu);
    
    Ms_hat = sqrt(Mu);
    
    D_Mu_sq = majorate_matrix(Mu, q_p, params_syms, params_lims);
    D_Mu_1_sq = majorate_matrix(Mu_1, q_p, params_syms, params_lims);
    
    D_Mu = eye(n) + sqrt(D_Mu_sq);
    D_Mu_1 = eye(n) + sqrt(D_Mu_1_sq);
    
    D = sym(zeros(n, n));
    
    for i = 1:n
        for j = 1:n
            dij_omega = D_Mu_sq(i, j);
            dij_omega_1 = D_Mu_1_sq(i, j);
            
            if(dij_omega >= dij_omega_1)
                D(i, j) = dij_omega;
            else
                D(i, j) = dij_omega_1;
            end
        end
    end
    
    Dtilde = D - diag(2*diag(D));
end

function D = majorate_matrix(matrix, q_p, params_syms, params_lims)
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
            sup_num = func_minmax(num, q_p, 0, label);
            sup_num = vpa(subs(sup_num, params_syms, params_max));
            
            inf_den = func_minmax(den, q_p, 1, label);
            inf_den = vpa(subs(inf_den, params_syms, params_min));
            
            if(i == j)
                d_ij = vpa((sup_num - inf_den)/(inf_den));
            else
                d_ij = vpa(sup_num/inf_den);
            end
        end
    end
end