% Bodies transformations
T0 = T3d(th, [0; 0; 1], [x_pos; y_pos; 0]);
T1 = T3d(0, [0; 1; 0], [0; w/2; 0]);
T2 = T3d(0, [0; 1; 0], [0; -w/2; 0]);
T3 = T3d(phi_r, [0; 1; 0], [0; 0; 0]);
T4 = T3d(phi_l, [0; 1; 0], [0; 0; 0]);
T5 = T3d(0, [0; 0; 1], [L_f; 0; 0]);
T6 = T3d(beta, [0; 0; 1], [0; 0; 0]);
T7 = T3d(phi_s, [0; 1; 0], [0; 0; -L_s]);

% Body 1 and 2 related transformation matrices
Ts_c = {T0};
Ts_l = {T0, T1};
Ts_r = {T0, T2};
Ts_f = {T0, T5, T6};
Ts_s = {T0, T5, T6};

% Previous body - Inertial, in this case
params_c = [m_c, diag(I_c)', L_c];
params_r = [m_r, diag(I_r)'];
params_l = [m_l, diag(I_l)'];
params_f = [m_f, diag(I_f)'];
params_s = [m_s, diag(I_s)'];

% Dampers and springs
damper_r = build_damper(b_r, [0; 0; 0], [0; phip_r; 0]);
damper_l = build_damper(b_l, [0; 0; 0], [0; phip_l; 0]);
damper_f = build_damper(b_f, [0; 0; 0], [0; beta; 0]);
damper_s = build_damper(b_s, [0; 0; 0], [0; phip_s; 0]);
