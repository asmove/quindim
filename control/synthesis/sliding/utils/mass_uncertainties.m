function Ms_struct = mass_uncertainties(Ms, q_p, params_syms, params_lims)
    
    n = length(Ms);
    
    % Parameter boundaries
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);
    
    Ms_min = subs(Ms, params_syms, params_min);
    Ms_max = subs(Ms, params_syms, params_max);
    
    % inv(Mu) = I + inv(Ms_hat)
    % Mu = I + Ms_hat
    Omega = Ms_max/Ms_min;
    Omega_1 = inv(Omega);
    Ms_hat = sqrt(Ms_max*Ms_min);
    
    Ms_struct.Ms_min = Ms_min;
    Ms_struct.Ms_max = Ms_max;
    Ms_struct.Omega = Omega;
    Ms_struct.Omega_1 = Omega_1;
    
    % D calculation
    D_Omega_sq_sup = supinf_matrix(Omega, q_p, params_syms, ...
                                   params_lims, 0);
    D_Omega_1_sq_sup = supinf_matrix(Omega_1, q_p, params_syms, ...
                                     params_lims, 0);
    
    D_Omega_sup = abs(-eye(n) + sqrt(D_Omega_sq_sup));
    D_Omega_1_sup = abs(-eye(n) + sqrt(D_Omega_1_sq_sup));
    D_Omega_sup = double(D_Omega_sup);
    D_Omega_1_sup = double(D_Omega_1_sup);
        
    for i = 1:n
        for j = 1:n
            if(D_Omega_sup(i, j) > D_Omega_1_sup(i, j))
                D(i, j) = D_Omega_sup(i, j);
            else
                D(i, j) = D_Omega_1_sup(i, j);
            end
        end
    end
    
    % Dtilde calculation
    D_Omega_sq_inf = supinf_matrix(Omega, q_p, ...
                                   params_syms, params_lims, 1);
    D_Omega_1_sq_inf = supinf_matrix(Omega_1, q_p, ...
                                     params_syms, params_lims, 1);
    
    I_m_D_Omega_inf = abs(sqrt(D_Omega_sq_inf));
    I_m_D_Omega_1_inf = abs(sqrt(D_Omega_1_sq_inf));
    I_m_D_Omega_inf = double(I_m_D_Omega_inf);
    I_m_D_Omega_1_inf = double(I_m_D_Omega_1_inf);
    
    for i = 1:n
        for j = 1:n
            if(I_m_D_Omega_inf(i, j) < I_m_D_Omega_1_inf(i, j))
                Dprime(i, j) = I_m_D_Omega_inf(i, j);
            else
                Dprime(i, j) = I_m_D_Omega_1_inf(i, j);
            end
        end
    end
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
            
            % Minorate matrix
            if(is_min)
                num_lim = invtriang_ineq(num, q_p, label, ...
                                         params_syms, params_lims, 1);
                
                den_lim = invtriang_ineq(den, q_p, label, ...
                                         params_syms, params_lims, 0);
            
            % Majorate matrix
            else
                num_lim = triang_ineq(num, q_p, label, ...
                                      params_syms, params_max, 0);
                                  
                den_lim = triang_ineq(den, q_p, label, ...
                                      params_syms, params_min, 1);
            end
            
            D(i, j) = num_lim/den_lim;
        end
    end
end