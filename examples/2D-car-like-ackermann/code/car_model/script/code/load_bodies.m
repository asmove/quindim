qc = [x_pos, y_pos, theta];
qpc = [xp, yp, thetap];
qppc = [xpp, ypp, thetapp];

qi = [x_pos, y_pos, theta, phi_i, delta_i].';
qpi = [xp, yp, thetap, phip_i, deltap_i].';
qppi = [xpp, ypp, thetapp, phipp_i, deltapp_i].';

qo = [x_pos, y_pos, theta, phi_o, delta_o].';
qpo = [xp, yp, thetap, phip_o, deltap_o].';
qppo = [xpp, ypp, thetapp, phipp_o, deltapp_o].';

qr = [x_pos, y_pos, theta, phi_r].';
qpr = [xp, yp, thetap, phip_r].';
qppr = [xpp, ypp, thetapp, phipp_r].';

ql = [x_pos, y_pos, theta, phi_l].';
qpl = [xp, yp, thetap, phip_l].';
qppl = [xpp, ypp, thetapp, phipp_l].';

% Previous body
previous = struct('');

Lg_c = [0; Lc; 0];
Lg_i = [0; 0; 0];
Lg_o = [0; 0; 0];
Lg_l = [0; 0; 0];
Lg_r = [0; 0; 0];

chassi = build_body(mc, I_c, Tcs, Lg_c, {}, {}, qc, qpc, qppc, previous, []);
inner_front_wheel = build_body(mi, I_i, Tis, Lg_i, {}, {}, qi, qpi, qppi, chassi, []);
outer_front_wheel = build_body(mo, I_o, Tos, Lg_o, {}, {}, qi, qpi, qppi, chassi, []);
inner_back_wheel = build_body(ml, I_l, Tls, Lg_r, {}, {}, ql, qpl, qppl, chassi, []);
outer_back_wheel = build_body(mr, I_r, Trs, Lg_l, {}, {}, qr, qpr, qppr, chassi, []);

sys.descrip.bodies = {chassi, ...
                      inner_front_wheel, outer_front_wheel, ...
                      inner_back_wheel, outer_back_wheel};