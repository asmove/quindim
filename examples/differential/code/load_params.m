sys.descrip.syms = [m_r, m_l, m_c, m_f, m_s, ...
                    R, R_s, g, L_c, w, Lg_f_y, ...
                    L_f, L_s, L, b_r, b_l, b_f, b_s, ...
                    diag(I_c).', diag(I_r).', ...
                    diag(I_l).', diag(I_f).', diag(I_s).'];

m_c_n = 0.5;
m_r_n = 0.15;
m_l_n = 0.15;
m_f_n = 0.1;
m_s_n = 0.1;

R_n = 5e-2;
R_s_n = 4e-2/2;
L_s_n = R_n - R_s_n;

g_n = 9.8;

L_n = 0.15;
L_c_n = L_n/2;
Lg_f_y_n = 2e-2;
L_f_n = 0.1;
w_n = 0.1;

b_r_n = 0;
b_l_n = 0;
b_f_n = 0;
b_s_n = 0;

Is_c = 0.01*ones(1, 3);
Is_r = 0.01*ones(1, 3);
Is_l = 0.01*ones(1, 3);
Is_f = 0.01*ones(1, 3);
Is_s = 0.01*ones(1, 3);

sys.descrip.model_params = [m_r_n, m_l_n, m_c_n, m_f_n, m_s_n, ...
                            R_n, R_s_n, g_n, L_c_n, w_n, ...
                            Lg_f_y_n, L_f_n, L_s_n, L_n, ...
                            b_r_n, b_l_n, b_f_n, b_s_n, ...
                            Is_c, Is_r, Is_l, Is_f, Is_s];

sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

sys.descrip.bodies = {chassi, wheel_r, wheel_l, front_support, wheel_s};

% Generalized coordinates
sys.kin.q = [x_pos; y_pos; th; beta_; phi_r; phi_l; phi_s];
sys.kin.qp = [xp; yp; thp; betap; phip_r; phip_l; phip_s];
sys.kin.qpp = [xpp; ypp; thpp; betapp; phipp_r; phipp_l; phipp_s];

sys.kin.p = sym('p', [2, 1]);
sys.kin.pp = sym('pp', [2, 1]);

% External excitations
sys.descrip.Fq = [0; 0; 0; tau_r; tau_l; 0; 0];
sys.descrip.u = [tau_r; tau_l];

% Constraint condition
sys.descrip.is_constrained = true;

% Sensors
sys.descrip.y = [phi_r; phi_l; phi_s];

% State space representation
sys.descrip.states = [sys.kin.q; sys.kin.p];
