function [q, qp, p] = states_to_q_qp_p(sys, states)
    [n_t, ~] = size(states);
    n_q = length(sys.kin.q);
    n_p = length(sys.kin.p);
    
    % Generalized coordinates and quasi-velocities
    q_n = states(:, 1:n_q);
    p_n = states(:, n_q + 1:end);
   
    % Generalized speeds and velocities
    q_s = sys.kin.q.';
    qp_s = sys.kin.qp.';
    p_s = sys.kin.p.';
    
    qp = zeros(n_t, n_q);
    
    for i = 1:n_t
        q_i = q_n(i, :);
        p_i = p_n(i, :);
        
        C_qp = sys.kin.C*sys.kin.p;
        
        C_qp_n = subs(C_qp, [q_s, p_s], [q_i, p_i]);
        
        qp(i, :) = vpa(C_qp_n)';
    end
    
    q = q_n;
    p = p_n;
end