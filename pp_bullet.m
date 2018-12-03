function pp_bullet_ = pp_bullet(mechanism, q_bullet, qp_bullet, qpp_bullet)
    D_bullet = subs(mechanism.D_bullet, mechanism.q_bullet, q_bullet);
    Dp_bullet = subs(mechanism.Dp_bullet, [mechanism.q_bullet, ...
                                           mechanism.qp_bullet], ...
                                          [q_bullet, qp_bullet]);

    pp_bullet_ = (D_bullet*qpp_bullet.' + Dp_bullet*qp_bullet.').';
end