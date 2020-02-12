function u_struct = control_calc(sys, control_info)
    W = control_info.W;

    is_positive(W);
    is_diagonal(W);
    
    % Main dynamic matrices
    p = sys.kin.p{end};
    q = sys.kin.q;
    H = sys.dyn.H;
    M = sys.dyn.M;
    C = sys.kin.C;
    x = sys.kin.q(1:2);
    h = sys.dyn.h;
    u = sys.descrip.u;
    Z = sys.dyn.Z;
    
    n_q = length(q);
    n_u = length(u);
    n_p = length(p);
    
    % Control utils
    q_hat = sym('qhat_', [n_q, 1]);
    p_hat = sym('phat_', [n_p, 1]);
    qp_hat = sym('qphat_', [n_q, 1]);
    pp_hat = sym('pphat_', [n_p, 1]);
    
    f = [C*p; -inv(H)*h];
    G = [zeros(n_q, n_u); inv(H)*Z];
    
    % x and p errors
    e_q = q - q_hat;
    e_qp = C*p - qp_hat;
    
    % Ljapunov function and its derivative
    poles = control_info.poles;
    Lambda = ctrb_canon(poles);
    
    e_term = e_qp - Lambda*e_q;
    V = e_term.'*M*e_term;

    model_params = sys.descrip.model_params.';
    syms_plant = sys.descrip.syms.';
    
    L_f_v_fun = @(V) lie_diff(f, V, [q; p]);
    L_G_v_fun = @(V) lie_diff(G, V, [q; p]);
    
    V_THRESHOLD = 0.1;
    u_struct.Vp_fun = @(V, e) terop(V >= V_THRESHOLD, ...
                                    control_info.Vp_fun(V, e), ...
                                    0);
    
    u_struct.Lfv_fun = @(V) vpa(L_f_v_fun(V));
    u_struct.LGv_fun = @(V, syms_params, num_params) vpa(L_G_v_fun(V));
    
    u_struct.error = e_term;
    u_struct.V_fun = @() vpa(V);
    u_struct.W = W;
end