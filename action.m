function u = action(mechanism, q0_circ, q_bullet, qp_bullet, qpp_bullet)
    
    % Generalized coordinates
    [q_num, qp_num, p_num, ~] = q_qp_p(mechanism, q0_circ, ...
                                       q_bullet, qp_bullet, qpp_bullet);
                                   
    [~, C, ~] = coupling_matrixC(mechanism, q_num);

    % Main evaluation matrices
    q_sym = [mechanism.eqdyn.q_bullet, mechanism.eqdyn.q_circ];
    qp_sym = [mechanism.eqdyn.qp_bullet, mechanism.eqdyn.qp_circ];
    p_sym = [mechanism.eqdyn.p_bullet, mechanism.eqdyn.p_circ];
    
    Mtilde = subs(mechanism.eqdyn.M_decoupled, q_sym, q_num);
    Utilde = subs(mechanism.eqdyn.U_decoupled, q_sym, q_num);
    nutilde = subs(mechanism.eqdyn.nu_decoupled, ...
                   [q_sym, qp_sym, p_sym], ...
                   [q_num, qp_num, p_num]);
    gtilde = subs(mechanism.eqdyn.g_decoupled, q_sym, q_num);
                                      
    M = double(Mtilde);
    U = double(Utilde);
    nu = double(nutilde);
    g = double(gtilde);
    
    % Main action variables
    H = C.'*M*C;
    Z = C.'*U;
    h = C.'*(M*Cp*bullet + nu - g);
    
    u = pinv(Z)*(H*pp_bullet.' + h);
end