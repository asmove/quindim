% Chassi
is_diag_c = true;
I_c = inertia_tensor('_c', is_diag_c);

% Right wheel
is_diag_r = true;
I_r = inertia_tensor('_r', is_diag_r);

% Left wheel
is_diag_l = true;
I_l = inertia_tensor('_l', is_diag_l);

% Front wheel support 
is_diag_f = true;
I_f = inertia_tensor('_f', is_diag_f);

is_diag_s = true;
I_s = inertia_tensor('_s', is_diag_s);

% Previous body - Inertial, in this case
params_c = [m_c, diag(I_c)', L_c];
params_r = [m_r, diag(I_r)'];
params_l = [m_l, diag(I_l)'];
params_f = [m_f, diag(I_f)'];
params_s = [m_s, diag(I_s)'];

% Dampers and springs
damper_r = build_damper(b_r, [0; 0; 0], [0; phip_r; 0]);
damper_l = build_damper(b_l, [0; 0; 0], [0; phip_l; 0]);
damper_f = build_damper(b_f, [0; 0; 0], [0; beta_; 0]);
damper_s = build_damper(b_s, [0; 0; 0], [0; phip_s; 0]);

% Position relative to body coordinate system
Lg_c = [0; L_c; 0];
Lg_r = [0; 0; 0];
Lg_l = [0; 0; 0];
Lg_f = [0; Lg_f_y; 0];
Lg_s = [0; 0; 0];

% Chassi
previous_c = struct('');

states_c = [x_pos, y_pos, th].';
speed_c = [xp, yp, thp].';
accel_c = [xpp, ypp, thpp].';

params_c = [];

chassi = build_body(m_c, I_c, Ts_c, Lg_c, {}, {}, ...
                    states_c, speed_c, accel_c, ...
                    previous_c, params_c);

% Right wheel
previous_r = chassi;

states_r = [x_pos, y_pos, th, phi_r].';
speed_r = [xp, yp, thp, phip_r].';
accel_r = [xpp, ypp, thpp, phipp_r].';

params_r = [];

wheel_r = build_body(m_r, I_r, Ts_r, Lg_r, {damper_r}, {}, ...
                     states_r, speed_r, accel_r, ...
                     previous_r, params_r);

% Left wheel
previous_l = chassi;

states_l = [x_pos, y_pos, th, phi_l].';
speed_l = [xp, yp, thp, phip_l].';
accel_l = [xpp, ypp, thpp, phipp_l].';

wheel_l = build_body(m_r, I_r, Ts_l, Lg_r, {damper_l}, {}, ...
                     states_l, speed_l, accel_l, ...
                     previous_l, params_l);

% Frontal support - Robot
previous_f = chassi;

states_f = [x_pos, y_pos, th, beta_].';
speed_f = [xp, yp, thp, betap].';
accel_f = [xpp, ypp, thpp, betapp].';

front_support = build_body(m_f, I_f, Ts_f, Lg_f, {damper_f}, {}, ...
                           states_f, speed_f, accel_f, ...
                           previous_f, params_f);

% Support wheel (Castor wheel)
previous_s = front_support;

states_s = [x_pos, y_pos, th, beta_, phi_s].';
speed_s = [xp, yp, thp, betap, phip_s].';
accel_s = [xpp, ypp, thpp, betapp, phipp_s].';

wheel_s = build_body(m_s, I_s, Ts_s, Lg_s, {damper_s}, {}, ...
                     states_s, speed_s, accel_s, ...
                     previous_s, params_s);