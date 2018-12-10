function [q, qp, p, is_workspace] = q_qp_p(mechanism, q0_circ, q_bullet, qp_bullet, qpp_bullet)
    % Speed to derivative coordinates conversion
    D_bullet = double(subs(mechanism.eqdyn.D_bullet, ...
                           mechanism.eqdyn.q_bullet, ...
                           q_bullet));
    
    Dp_bullet = double(subs(mechanism.eqdyn.Dp_bullet, ...
                            [mechanism.eqdyn.q_bullet, ...
                            mechanism.eqdyn.qp_bullet], ...
                            [q_bullet, qp_bullet]));

    % Independent speed
    p_bullet = D_bullet*qp_bullet.';
    p_bullet = p_bullet.';
    
    % Indepedent acceleration
    pp_bullet = D_bullet*qpp_bullet.' + Dp_bullet*qp_bullet.';
    pp_bullet = pp_bullet.';

    % Dependent coordinates
    t0 = tic;
    [q_circ_, is_workspace] = q_circ(mechanism, q0_circ, q_bullet);
    toc(t0);
    
    % Dependent speeds
    [~, ~, C_hat] = coupling_matrixC(mechanism, [q_bullet, q_circ_]);
    p_circ_ = C_hat*p_bullet.';
    p_circ_ = p_circ_.';

    % Speed to derivative coordinates conversion
    D_circ = subs(mechanism.eqdyn.D_circ, ...
                  mechanism.eqdyn.q_circ, ...
                  q_circ_);
       
    % Dependent coordinates derivatives
    qp_circ_ = pinv(D_circ)*p_circ_.';
    qp_circ_ = qp_circ_.';

    Dp_circ = subs(mechanism.eqdyn.Dp_circ, ...
                   [mechanism.eqdyn.q_circ, ...
                    mechanism.eqdyn.qp_circ], ...
                   [q_circ_, qp_circ_]);

    % Generalized variables
    q = double([q_bullet, q_circ_]);
    qp = double([qp_bullet, qp_circ_]);
    p = double([p_bullet, p_circ_]);
end