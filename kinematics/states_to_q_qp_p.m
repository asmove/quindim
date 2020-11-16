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
    C_q = subs(C, syms, model_params);
        
    symvars_C = symvar(C_q);
    
    idxs = [];
    for i = 1:length(symvars_C)
        svar = symvars_C(i);

        idx = find(q_s == svar);
        if(~isempty(idx))
            idxs = [idxs; idx];
        end
    end
    
    wb = my_waitbar('(q, p) -> qp');    
    for i = 1:n_t
        q_i = q_n(i, :);
        p_i = p_n(i, :);
        
        C_qp = C_q*p_i';
        
        q_s_ = q_s(idxs);
        q_i = q_i(idxs);
        
        C_qp_n = subs(C_qp, q_s_, q_i);
        qp(i, :) = vpa(C_qp_n');
    
        wb.update_waitbar(i, n_t);
    end
    
    % wb.close_window();
        
    q = q_n;
    p = p_n;
end