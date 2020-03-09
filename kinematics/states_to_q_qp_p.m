function [q, qp, p] = states_to_q_qp_p(sys, states)
    [n_t, ~] = size(states);
    n_q = length(sys.kin.q);
    
    % Generalized coordinates and quasi-velocities
    q_n = states(:, 1:n_q);
    p_n = states(:, n_q + 1:end);
   
    % Generalized speeds and velocities
    q_s = sys.kin.q.';
    qp_s = sys.kin.qp.';
    p_s = sys.kin.p{end};
    syms = sys.descrip.syms;
    model_params = sys.descrip.model_params;
    
    qp = zeros(n_t, n_q);
    
    C = sys.kin.C;
    
    for i = 1:n_t
        q_i = q_n(i, :);
        p_i = p_n(i, :);
        
        C_qp = C*p_s;
        
        symbs = [q_s, p_s.', syms];
        nums = [q_i, p_i, model_params];
        
        C_qp_n = subs(C_qp, symbs, nums);
        
        qp(i, :) = vpa(C_qp_n');
    end
        
    q = q_n;
    p = p_n;
end