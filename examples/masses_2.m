% Author: Senzu
% Date: 08/01/19

% Body 1
syms m1 b1 real;
syms x1 x1p x1pp real;

I1 = sym(zeros(3, 3));

T1s = {T3d(0, [0; 0; 1], [x1; 0; 0])};
is_friction_linear1 = true;

% Previous body - Inertial, in this case
% CG position relative to body coordinate system
L1 = [0; 0; 0];

% Body 2
syms x2 x2p x2pp real;
syms m2 b2 real;

% CG position relative to body coordinate system
L2 = [0; 0; 0];

I2 = sym(zeros(3, 3));
T2s = {T3d(0, [0; 0; 1], [x2; 0; 0])};
is_friction_linear2 = true;

% Bodies inertia
previous1 = struct('');
body1 = build_body(m1, I1, b1, T1s, L1, x1, x1p, x1pp, ...
                      is_friction_linear1, previous1);

% Body 2
previous2 = body1;

body2 = build_body(m2, I2, b2, T2s, L1, x2, x2p, x2pp, ...
                      is_friction_linear2, previous2);

syms g;
syms u;

sys.bodies = {body1, body2};

% Gravity utilities
sys.gravity = [0; 0; -g];
sys.g = g;

% Generalized coordinates
sys.q = [x1; x2];
sys.qp = [x1p; x2p];
sys.qpp = [x1pp; x2pp];

% External excitations
sys.Fq = [0; u];
sys.u = u;

% Sensors
sys.y = [x1; x2];

% State space representation
sys.states = [x1; x2; x1p; x2p];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

