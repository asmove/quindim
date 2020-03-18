function Ms_struct = mass_uncertainties2(Ms, q_p, params_s, params_lims)
    
    n = length(Ms);
    
    % Parameter boundaries
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);
    
    Ms_min = subs(Ms, params_s, params_min);
    Ms_max = subs(Ms, params_s, params_max);
    
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
    F = abs(sqrt(adjoint(Ms_max)*Ms_min) - sqrt(det(Ms_max))*eye(n));
    G = abs(sqrt(adjoint(Ms_min)*Ms_max) - sqrt(det(Ms_min))*eye(n));
    den_D = abs(sqrt(det(Ms_min)));
    den_D = subs(den_D, params_s, params_lims(:, 1));
    
    Ms_struct.F = F;
    Ms_struct.G = G;
    Ms_struct.den_D = den_D;
    Ms_struct.Ms_hat = Ms_hat;
    
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

