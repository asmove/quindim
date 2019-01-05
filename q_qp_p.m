function [q, qp, p, pp, is_workspace] = q_qp_p(mechanism, q0_circ, ...
                                               q_bullet, qp_bullet, ...
                                               qpp_bullet)
    q0_circ
    % Speed to derivative coordinates conversion
    D_bullet = double(subs(mechanism.eqdyn.D_bullet, ...
                           mechanism.eqdyn.q_bullet, ...
                           q_bullet));
    
    Dp_bullet = double(subs(mechanism.eqdyn.Dp_bullet, ...
                            [mechanism.eqdyn.q_bullet, ...
                             mechanism.eqdyn.qp_bullet], ...
                            [q_bullet, qp_bullet]));
                        
    n_bullet = length(mechanism.eqdyn.q_bullet);
    n_circ = length(mechanism.eqdyn.q_circ);
    
    % Independent speed
    p_bullet = D_bullet*qp_bullet;
    
    % Indepedent acceleration
    pp_bullet = D_bullet*qpp_bullet + Dp_bullet*qp_bullet;

    % Dependent coordinates
    t0 = tic;
    [q_circ_, is_workspace] = q_circ(mechanism, q0_circ, q_bullet);
    toc(t0);
        
    % Dependent speeds
    % TAKE NOTE: Zeros for qp 'cause it is irrelevant here
    [~, Chat, ~] = coupling_matrixC(mechanism, [q_bullet; q_circ_], ...
                                    zeros(size([q_bullet; q_circ_])));
    p_circ_ = Chat*p_bullet;

    % Speed to derivative coordinates conversion
    D_circ = subs(mechanism.eqdyn.D_circ, mechanism.eqdyn.q_circ, q_circ_);
              
    % Dependent coordinates derivatives
    qp_circ_ = pinv(D_circ)*p_circ_;
    q = double([q_bullet; q_circ_]);
    qp = double([qp_bullet; qp_circ_]);
    p = double([p_bullet; p_circ_]);
    
    [A, Ap] = coupling_matrixA(mechanism, q, qp);
    A_circ = A(:, n_bullet+1:end);
    A_bullet = A(:, 1:n_bullet);    
    
    pp_circ = -A_circ\(Ap*p + A_bullet*p_bullet);
    
    % Generalized variables
    pp = double([pp_bullet; pp_circ]);
end