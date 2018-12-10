function sim = update_sim(i, sim, mechanism, trajectory)
% Update trajectory simulation parameters e.g.matrix C, 
% M, nu, g, generalized coordinates and speeds

    % First iteration
    if((i == 1)||(i==2))
        % Instants
        sim = struct('prev_t', trajectory.t(1), ...
                     'curr_t', trajectory.t(2));
                 
        % Generalized variables for Cp 
        q_bullet0 = trajectory.q(3, :);
        qp_bullet0 = trajectory.qp(3, :);
        qpp_bullet0 = trajectory.qpp(3, :);
             
        % Generalized variables - Instant k-1
        q_bullet_1 = trajectory.q(2, :);
        qp_bullet_1 = trajectory.qp(2, :);
        qpp_bullet_1 = trajectory.qp(2, :);
        

        % Generalized variables - Instant k-2
        q_bullet_2 = trajectory.q(1, :);
        qp_bullet_2 = trajectory.qp(1, :);
        qpp_bullet_2 = trajectory.qp(1, :);
        
        q0_circ = zeros(1, 6);
    else
        % Instants
        sim.prev_t = trajectory.t(i-1);
        sim.curr_t = trajectory.t(i);
        
        % Generalized variables
        q_bullet0 = trajectory.q(i, :);
        qp_bullet0 = trajectory.qp(i, :);
        qpp_bullet0 = trajectory.qpp(i, :);
             
        % Generalized variables
        q_bullet_1 = trajectory.q(i-1, :);
        qp_bullet_1 = trajectory.qp(i-1, :);
        qpp_bullet_1 = trajectory.qp(i-1, :);
        
        % Generalized variables
        q_bullet_2 = trajectory.q(i-2, :);
        qp_bullet_2 = trajectory.qp(i-2, :);
        qpp_bullet_2 = trajectory.qp(i-2, :);
        
        idx_q_circ = length(q_bullet0)+1;
        q0_circ = sim.q(idx_q_circ:end);
    end
    
    q_bullet_i = trajectory.q(i, :);
    qp_bullet_i = trajectory.qp(i, :);
    qpp_bullet_i = trajectory.qpp(i, :);
    
    % Evaluated variables
    [q0, ~, p0] = q_qp_p(mechanism, ...
                            q0_circ, ...
                            q_bullet0, ...
                            qp_bullet0, ...
                            qpp_bullet0);
                        
    [q_1, ~, ~] = q_qp_p(mechanism, ...
                                 q0_circ, ...
                                 q_bullet_1, ...
                                 qp_bullet_1, ...
                                 qpp_bullet_1);
                             
    [q_2, ~, ~] = q_qp_p(mechanism, ...
                           q0_circ, ...
                           q_bullet_2, ...
                           qp_bullet_2, ...
                           qpp_bullet_2);
    
    % Cp - Backward approximation O(h^3)
    [~, C0, ~] = coupling_matrixC(mechanism, q0);
    [~, C_1, ~] = coupling_matrixC(mechanism, q_1);
    [~, C_2, ~] = coupling_matrixC(mechanism, q_2);
    
    sim.C0 = C0;
    sim.C_1 = C_1;
    sim.C_2 = C_2;
    
    delta_t = sim.curr_t - sim.prev_t;
    Cp = (1.5*C0 - 2*C_1 + 0.5*C_2)/delta_t;
    sim.Cp = Cp;
    
    [q_i, ~, p_i] = q_qp_p(mechanism, ...
                         q0_circ, ...
                         q_bullet_i, ...
                         qp_bullet_i, ...
                         qpp_bullet_i);
    
    sim.ti = trajectory.t(i);
                     
    [~, Ci, ~] = coupling_matrixC(mechanism, q_i);                 
    
    sim.C = Ci;
    
    % Main generalized variables
    sim.q = q_i;
    sim.p = p_i;
    
    % Main evaluation matrices
    q = [mechanism.eqdyn.q_bullet, mechanism.eqdyn.q_circ];
    p = [mechanism.eqdyn.p_bullet, mechanism.eqdyn.p_circ];
    
    % Serial/Endeffector decoupled variables
    M_tilde = double(subs(mechanism.eqdyn.M_decoupled, q, q_i));
    nu_tilde = double(subs(mechanism.eqdyn.nu_decoupled, [q, p], [q_i, p_i]));
    g_tilde = double(subs(mechanism.eqdyn.g_decoupled, q, q_i));
    U_tilde = double(subs(mechanism.eqdyn.U_decoupled, q, q_i));
    
    n_bullet = length(mechanism.eqdyn.q_bullet);
    p_bullet = p0(1:n_bullet).';
    
    pp_bullet_ = pp_bullet(mechanism, q_bullet_i, ...
                                      qpp_bullet_i, ...
                                      qpp_bullet_i);
    
    % Control variables
    H = C0.'*M_tilde*C0;
    Z = C0.'*U_tilde;
    h = C0.'*(M_tilde*Cp*p_bullet + nu_tilde - g_tilde);
    
    u = pinv(Z)*(H*pp_bullet_.' + h);
    sim.u = double(u);
    
    n_points = length(mechanism.points);
    n_bars = length(mechanism.bars);
    
    sim.points = {};
    for i = 1:n_points
        % Default values
        sim.points{end+1} = struct('coords', [0, 0, 0], ...
                                   'marker', '*', ...
                                   'color', 'k');
        
        sim.points{i}.coords = double(subs(mechanism.points{i}.coords, ...
                                           q, q0));
        sim.points{i}.marker = mechanism.points{i}.marker;
        sim.points{i}.color = mechanism.points{i}.color;
    end
    
    sim.bars = {};
    for i = 1:n_bars
        % Default values
        sim.bars{end+1} = struct('begin', [0, 0, 0], ...
                                   'end', [0, 0, 0], ...
                                   'width', 1, ...
                                   'color', 'k');
        
        sim.bars{i}.begin = double(subs(mechanism.bars{i}.begin, q, q0));
        sim.bars{i}.end = double(subs(mechanism.bars{i}.end, q, q0));
        sim.bars{i}.width = mechanism.bars{i}.width;
        sim.bars{i}.color = mechanism.bars{i}.color;
    end
end