if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

n_mbk = int(input('Insert the MBK size:'));

previous_i = struct('');

for i = 1:n_mbk
    % Body 1
    syms m1 b1 k1 real;
    syms x1 x1p x1pp real;

    m_i = sym('m', 1);
    b_i = sym('b', 1);
    k_i = sym('k', 1);
    x_i = sym('x_', 1);
    xp_i = sym('xp_', 1);
    xpp_i = sym('xpp_', 1);
    I_i = sym(zeros(3, 3));

    T1s = {T3d(0, [0; 0; 1], [x_i; 0; 0])};
    is_friction_linear1 = true;

    % Previous body - Inertial, in this case
    % CG position relative to body coordinate system
    L_i = [0; 0; 0];

    % Bodies inertia
    damper_i = build_damper(b1, [0; 0; 0], [x1p; 0; 0]);
    spring_i = build_spring(k1, [0; 0; 0], [x1; 0; 0]);

    body_i = build_body(m_i, I_i, Ts_i, L_i, {damper_i}, {spring_i}, ...
                        x_i, xp_i, xpp_i, previous_i, []);
    
    previous_i = body_i;
end

syms g u1;

sys.descrip.syms = [m1, b1, k1, m2, b2, k2, g];

% Paramater symbolics of the system
sys.descrip.model_params = [1, 1, 9, 1, 1, 9, 9.8];

sys.descrip.bodies = {body1, body2};

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Generalized coordinates
sys.kin.q = [x1; x2];
sys.kin.qp = [x1p; x2p];
sys.kin.qpp = [x1pp; x2pp];

% Quasi-velocities
sys.kin.p = [x1p; x2p];
sys.kin.pp = [x1pp; x2pp];

% External excitations
sys.descrip.Fq = [u1; 0];
sys.descrip.u = u1;

% Sensors
sys.descrip.y = [x1; x2];

% State space representation
sys.dyn.states = [x1; x2; x1p; x2p];

% Constraint condition
sys.descrip.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Decay time
m_num = sys.descrip.model_params(1);
b_num = sys.descrip.model_params(2);
T = m_num/b_num;

