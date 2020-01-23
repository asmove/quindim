function [p, pp] = q_qp_qpp_to_p_pp(q, qp, qpp, sys)
    C = sys.kin.C;
    Cp = sys.kin.Cp;
    
    n = length(sys.kin.q);
    m = length(sys.kin.p);
    
    model_params = sys.descrip.model_params;
    syms = sys.descrip.syms;
    
    q_s = sys.kin.q;
    p_s = sys.kin.p{end};
    
    C_num = subs(C, [q_s.', syms], [q.', model_params]);
    
    [U, S, V] = svd(C_num);
    W = U';
    W1 = W(1:m, :);
    
    W1_C = W1*C_num;
    p = W1_C\(W1*qp);

    Cp_num = subs(Cp, [q_s.', p_s.', syms], [q.', p.', model_params]);
    
    pp = W1*(qpp - Cp_num*p);
end