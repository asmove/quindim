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
    
    det_Ms_max = det(Ms_max);
    det_Ms_min = det(Ms_min);
    adjMs_max_Ms_min = adjoint(Ms_max)*Ms_min;
    adjMs_min_Ms_max = adjoint(Ms_min)*Ms_max;
    
    % D calculation
    F = abs(sqrt(adjMs_max_Ms_min) - det(Ms_max)*eye(n));
    G = abs(sqrt(adjMs_min_Ms_max) - det(Ms_min)*eye(n));
    den_D = det(Ms_min);
    den_D = subs(den_D, params_s, params_lims(:, 1));
    
    Ms_struct.F = F;
    Ms_struct.G = G;
    Ms_struct.den_D = den_D;
    Ms_struct.Ms_hat = Ms_hat;
    
%     params_hat_s = add_symsuffix(params_s, '_hat');
%     params_syms = [params_s; params_hat_s];
%     params_num = [params_max; params_max];
%     
%     num_sups = [];
%     for i = 1:n
%         for j = 1:n
%             msg = ['D calculation ', '', num2str(i), ', ', num2str(j), ''];
%             
%             adjMs_max_Ms_min_ij = adjMs_max_Ms_min(i, j);
%             adjMs_min_Ms_max_ij = adjMs_min_Ms_max(i, j);
%             
%             is_min = false;
%             adjMs_max_Ms_min_ij_sup = triang_ineq(adjMs_max_Ms_min_ij, ...
%                                                   q_p, msg, params_syms, ...
%                                                   is_max, is_min);
%             
%             adjMs_max_Ms_min_ij_sup = triang_ineq(adjMs_min_Ms_max_ij, ...
%                                                   q_p, msg, params_syms, ...
%                                                   is_max, is_min);
%             
%             if(adjMs_max_Ms_min_ij_sup >= adjMs_max_Ms_min_ij_sup)
%                 num_sups(i, j) = adjMs_max_Ms_min_ij_sup;
%             else
%                 num_sups(i, j) = adjMs_max_Ms_min_ij_sup;
%             end
%         end
%     end
%     
%     is_min = false;
%     det_Ms_min_sup = triang_ineq(det_Ms_min, q_p, msg, ...
%                                  params_syms, is_min);
%     
%     det_Ms_max_sup = triang_ineq(det_Ms_max, q_p, msg, ...
%                                  params_syms, is_min);
%                              
%     is_min = true;
%     den_D_inf = triang_ineq(den_D, q_p, msg, params_syms, is_min);
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

