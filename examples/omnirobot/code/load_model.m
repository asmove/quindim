% Omnirobot
% @Author: Bruno Peixoto
if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all

% The 'real' statement on end is important for inner simplifications
syms tau1 tau2 tau3 m_r m_R R r L g real;
syms Lg_x Lg_y b1 b2 b3 real;
syms phi1 phi1p phi1pp real;
syms phi2 phi2p phi2pp real;
syms phi3 phi3p phi3pp real;

syms x xp xpp real;
syms y yp ypp real;
syms th thp thpp real;

% Body inertia
is_diag1 = true;
I_r = inertia_tensor('r', is_diag1);

is_diag2 = true;
I_R = inertia_tensor('R', is_diag2);

% Position relative to body coordinate system
Lg_r = [0; 0; 0];
Lg_R = [0; 0; 0];

% Bodies transformations
T0 = T3d(th, [0; 0; 1], [x; y; 0]);

T1 = T3d(phi1, [1; 0; 0], [L; 0; 0]);

T2 = T3d(2*pi/3, [0; 0; 1], [0; 0; 0]);
T3 = T3d(phi2, [1; 0; 0], [L; 0; 0]);

T4 = T3d(4*pi/3, [0; 0; 1], [0; 0; 0]);
T5 = T3d(phi3, [1; 0; 0], [L; 0; 0]);

% Body 1 and 2 related transformation matrices
Ts_R = {T0};
Ts_r1 = {T0, T1};
Ts_r2 = {T0, T2, T3};
Ts_r3 = {T0, T4, T5};

% Previous body - Inertial, in this case
previous_R = struct('');

params_R = [m_R, diag(I_R)', L, Lg_x, Lg_y];
params_r1 = [m_r, diag(I_r)'];
params_r2 = [m_r, diag(I_r)'];
params_r3 = [m_r, diag(I_r)'];

% Damper and springs
damper1 = build_damper(b1, [0; 0; 0], [phi1p; 0; 0]);
damper2 = build_damper(b2, [0; 0; 0], [phi2p; 0; 0]);
damper3 = build_damper(b3, [0; 0; 0], [phi3p; 0; 0]);

states_main = [x, y, th].';
speed_main = [xp, yp, thp].';
accel_main = [xpp, ypp, thpp].';

params_R = [];

main_body = build_body(m_R, I_R, Ts_R, Lg_R, {}, {}, ...
                       states_main, speed_main, accel_main, ...
                       previous_R, params_R);
                   
previous_r1 = main_body;

states_main = [states_main; phi1];
speed_main = [speed_main; phi1p];
accel_main = [accel_main; phi1pp];

wheel_1 = build_body(m_r, I_r, Ts_r1, Lg_r, {damper1}, {}, ...
                     states_main, speed_main, accel_main, ...
                     previous_r1, params_r1);

previous_r2 = main_body;

states_main = [states_main; phi2];
speed_main = [speed_main; phi2p];
accel_main = [accel_main; phi2pp];

wheel_2 = build_body(m_r, I_r, Ts_r2, Lg_r, {damper2}, {}, ...
                     states_main, speed_main, accel_main, ...
                     previous_r2, params_r2);
                 
previous_r3 = main_body;

states_main = [states_main; phi3];
speed_main = [speed_main; phi3p];
accel_main = [accel_main; phi3pp];

wheel_3 = build_body(m_r, I_r, Ts_r3, Lg_r, {damper3}, {}, ...
                     states_main, speed_main, accel_main, ...
                     previous_r3, params_r3);

rho = 1050e-3;
ell = 86e-3;
h = 9e-3;
R_n = 86e-3;
r_n = 55e-3;
m_r_n = 74e-3;
m_R_n = 200e-3;
L_n = 25e-2;
I0_1_n = 0;
I0_2_n = 0;
I0_3_n = (rho*ell^4)*(9*sqrt(3)/32)*h;
I1_1_n = (1/12)*(3*r_n^2 + h^2);
I1_2_n = (1/12)*(3*r_n^2 + h^2);
I1_3_n = (1/12)*r_n^2;
Lg_x_n = 0;
Lg_y_n = 0;
b1_n = 0.0;
b2_n = 0.0;
b3_n = 0.0;
g_n = 9.8;
                 
sys.descrip.syms = [m_r, L, Lg_x, Lg_y, ...
                    m_R, diag(I_r).', diag(I_R).', ...
                    b1, b2, b3, g, R, r];

sys.descrip.model_params = [m_r_n, L_n, Lg_x_n, Lg_y_n, ...
                            m_R_n, I0_1_n, I0_2_n, I0_3_n, ...
                            I1_1_n, I1_2_n, I1_3_n, ...
                            b1_n, b2_n, b3_n, g_n, R_n, r_n];

sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

sys.descrip.bodies = {main_body, wheel_1, wheel_2, wheel_3};

% Generalized coordinates
sys.kin.q = [x; y; th; phi1; phi2; phi3];
sys.kin.qp = [xp; yp; thp; phi1p; phi2p; phi3p];
sys.kin.qpp = [xpp; ypp; thpp; phi1pp; phi2pp; phi3pp];

% Generalized coordinates
sys.kin.p = [xp; yp; thp; phi1p; phi2p; phi3p];
sys.kin.pp = [xpp; ypp; th; phi1pp; phi2pp; phi3pp];

% External excitations
sys.descrip.Fq = [0; 0; 0; tau1; tau2; tau3];
sys.descrip.u = [tau1; tau2; tau3];

% Constraint condition
sys.descrip.is_constrained = true;

% Sensors
sys.descrip.y = [phi1; phi2; phi3];

% State space representation
sys.descrip.states = [sys.kin.q; sys.kin.p];

q_qp = [sys.kin.qp; sys.kin.q];

sys.descrip.latex_origs = latexify_vars(q_qp);
sys.descrip.latex_text = {'\dot{x}', '\dot{y}', ...
                          '\dot{\theta}', '\dot{\phi}_1', ...
                          '\dot{\phi}_2', '\dot{\phi}_3', ...
                          'x', 'y', '\phi', '\phi_1', ...
                          '\phi_2', '\phi_1'};

q = sys.kin.q;
qp = sys.kin.qp;

p1 = point(T0*T1, [0; 0; 0]);
p2 = point(T0*T2*T3, [0; 0; 0]);
p3 = point(T0*T4*T5, [0; 0; 0]);

R0 = rot3d(th, [0; 0; 1]);
R1 = rot3d(0, [0; 0; 1]);
R2 = rot3d(2*pi/3, [0; 0; 1]);
R3 = rot3d(4*pi/3, [0; 0; 1]);

R01 = R0*R1;
R02 = R0*R2;
R03 = R0*R3;

i1 = R01(:, 1);
i2 = R02(:, 1);
i3 = R03(:, 1);

j1 = R01(:, 2);
j2 = R02(:, 2);
j3 = R03(:, 2);

u1 = dvecdt(p1, q, qp);
u2 = dvecdt(p2, q, qp);
u3 = dvecdt(p3, q, qp);

omega_1 = omega(R01, q, qp) + R01*[phi1p; 0; 0];
omega_2 = omega(R01, q, qp) + R02*[phi2p; 0; 0];
omega_3 = omega(R01, q, qp) + R03*[phi3p; 0; 0];

u_c1 = u1 + cross(omega_1, [0; 0; -R]);
u_c2 = u2 + cross(omega_2, [0; 0; -R]);
u_c3 = u3 + cross(omega_3, [0; 0; -R]);


sys.descrip.unhol_constraints = simplify_([dot(u_c1, j1); ...
                                           dot(u_c2, j2); ...
                                           dot(u_c3, j3)]);

% Kinematic and dynamic model
sys = kinematic_model(sys);

C13 = sys.kin.C(1:3, :);
T = simplify_(inv(C13));

sys = iso_speeds(sys, T);

sys = dynamic_model(sys);
