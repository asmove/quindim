function [q, p, pp] = generalized_variables(mechanism, q_bullet, qp_bullet, qpp_bullet)  
    % Speed to derivative coordinates conversion
    D_bullet = subs(mechanism.D_bullet, ...
                    mechanism.q_bullet, ...
                    q_bullet);
    
    Dp_bullet = subs(mechanism.Dp_bullet, ...
                     [mechanism.q_bullet, ...
                      mechanism.qp_bullet], ...
                     [q_bullet, qp_bullet]);
                 
    % Speed to derivative coordinates conversion
    D_circ = subs(mechanism.eqdyn.D_circ, ...
                  mechanism.eqdyn.q_circ, ...
                  q_bullet);
    
    Dp_circ = subs(mechanism.eqdyn.Dp_circ, ...
                   [mechanism.eqdyn.q_circ, ...
                    mechanism.eqdyn.qp_circ], ...
                   [q_circ, qp_circ]);

    % Dependent coordinates
    q_circ_ = q_circ(mechanism, q_bullet);
    
    % Dependent speeds
    p_circ_ = p_circ(mechanism, q_bullet, qp_bullet);
    
    % Depedent acceleration
    pp_circ = D_circ*qpp_circ.' + Dp_circ*qp_circ.';
    pp_circ = pp_circ.';
    
    % Independent speed
    p_bullet = D_bullet*qp_bullet;
    
    % Indepedent acceleration
    pp_bullet = D_bullet*qpp_bullet.' + Dp_bullet*qp_bullet.';
    pp_bullet = pp_bullet.';

    % depedent acceleration
    pp_bullet = D_bullet*qpp_bullet.' + Dp_bullet*qp_bullet.';
    pp_bullet = pp_bullet.';
    
    % Indepedent acceleration
    pp_bullet = D_bullet*qpp_bullet.' + Dp_bullet*qp_bullet.';
    pp_bullet = pp_bullet.';
    
    % Generalized variables
    q = [q_bullet, q_circ_];
    p = [p_bullet, p_circ_];
    pp = [pp_bullet, pp_circ_];
end