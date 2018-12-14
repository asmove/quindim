function pp_bullet_ = pp_bullet(mechanism, q_bullet, qp_bullet, qpp_bullet)
    D_bullet = subs(mechanism.eqdyn.D_bullet, mechanism.eqdyn.q_bullet, q_bullet);
    Dp_bullet = subs(mechanism.eqdyn.Dp_bullet, [mechanism.eqdyn.q_bullet, ...
                                           mechanism.eqdyn.qp_bullet], ...
                                          [q_bullet, qp_bullet]);

    pp_bullet_ = (D_bullet*qpp_bullet.' + Dp_bullet*qp_bullet.').';
end