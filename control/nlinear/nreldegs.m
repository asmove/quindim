function reldeg_struct = nreldegs(f, G, y, x)
    % Array sizes
    p = length(y);
    [~, m] = size(G);
    
    % Relative degrees
    deltas = [];
    
    % Required term on exact linearization
    phis = sym([]);
    
    % Coupling matrix
    Delta = sym([]);
    
    % Coordinate transformation 
    transfs = sym([]);
    
    recalc_Delta = true;
    
    n_tilde = length(f);
    f_tilde = f;
    G_tilde = G;
    h_tilde = y;
    states_tilde = x;
    
    u_tilde = sym('u', [m, 1]);
    pos_z = 0;
    
    is_fullrank = false;
    aux = 0;
    
    for i = 1:p
        j = 0;
        hi = y(i);

        % i-th Lie derivative for h respective to f
        lie_i_f_hi = hi;
        
        % Search for relative degree
        while(true)
            % Iteration relative degree
            j = j + 1;
            transfs = [transfs; lie_i_f_hi];
            
            % Lie of (i-th Lie derivative of hi  respective f) respective to G
            lie_G = sym([]);
            
            for k = 1:m
                gk = G_tilde(:, k);    
                lie_gk = lie_diff(gk, lie_i_f_hi, states_tilde);
                
                lie_G(end+1) = lie_gk;
            end
            
            % 
            if(~isempty(symvar(lie_G)))
                Delta = [Delta; lie_G];
                deltas(end+1) = j;
                
                break;
            
            % Empty G vector
            elseif(all(all(double(lie_G))))
                Delta = [Delta; lie_G];
                deltas(end+1) = j;
                
                break;
            end
            
            lie_i_f_hi = lie_diff(f_tilde, lie_i_f_hi, states_tilde);
        end

        % Vector with Lie derivative
        lie_delta_f_hi = lie_diff(f_tilde, lie_i_f_hi, states_tilde);
        phis = [phis; lie_delta_f_hi];
    end

%     rank_Delta = rank(Delta);
%     is_fullrank = rank_Delta == min(m, sum(deltas));
%     
%     while(~is_fullrank)
%         rank_Delta = rank(Delta);        
%         if(rank_Delta == p)
%             msg = sprintf("The system has total relative degree %d", sum(deltas));
%             disp(msg);
%             break;
%         
%         else
%             det_Delta2 = det(Delta*Delta.');
% 
%             if(~isempty(symvar(det_Delta2)))
%                 msg = 'System might be extended by addition of integrators.';
%                 error(msg);
%             end
%             
%             [beta, U] = lu(Delta);
% 
%             beta_1 = beta(:, 1:rank_Delta);
%             beta_2 = beta(:, rank_Delta+1:end);
% 
%             z_tilde = sym(sprintf('z_%s', num2str(pos_z)), [rank_Delta, 1]);
%             
%             f_tilde = [f_tilde + G_tilde*beta_1*z_tilde; ...
%                        zeros([rank_Delta, 1])];
% 
%             G_tilde = [zeros([n_tilde, 1]), ...
%                        G_tilde*beta_2; ...
%                        eye(rank_Delta), ...
%                        zeros([rank_Delta, m - rank_Delta])];
%             
%             n_tilde = n_tilde + rank_Delta;
% 
%             states_tilde = [states_tilde; z_tilde];
%             pos_z = pos_z + rank_Delta;
% 
%             Delta = [];
%         end
%     end
    
    reldeg_struct.deltas = deltas;
    reldeg_struct.transfs = transfs;
    reldeg_struct.phis = phis;
    reldeg_struct.Delta = Delta;
    reldeg_struct.f_tilde = f_tilde;
    reldeg_struct.G_tilde = G_tilde;
end