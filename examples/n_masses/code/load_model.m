if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

syms g real;

n_mbk = input('Insert the MBK size:');

previous_i = struct('');

Ts_prev = {};
x_prev = [];
xp_prev = [];
xpp_prev = [];

sys.descrip.syms = [];
sys.descrip.model_params = [];
sys.descrip.bodies = {};

for i = 1:n_mbk
    % Body 1
    m_i = sym(sprintf('m%d', i));
    b_i = sym(sprintf('b%d', i));
    k_i = sym(sprintf('k%d', i));
    x_i = sym(sprintf('x_%d', i));
    xp_i = sym(sprintf('xp_%d', i));
    xpp_i = sym(sprintf('xpp_%d', i));
    I_i = sym(zeros(3, 3));
    
    Ts_i = T3d(0, [0; 0; 1], [x_i; 0; 0]);
    Ts_prev = [Ts_prev, {Ts_i}];
    
    x_prev = [x_prev; x_i];
    xp_prev = [xp_prev; xp_i];
    xpp_prev = [xpp_prev; xpp_i];
    
    is_friction_linear1 = true;

    % Previous body - Inertial, in this case
    % CG position relative to body coordinate system
    L_i = [0; 0; 0];

    % Bodies inertia
    damper_i = build_damper(b_i, [0; 0; 0], [xp_i; 0; 0]);
    spring_i = build_spring(k_i, [0; 0; 0], [x_i; 0; 0]);
    
    body_i = build_body(m_i, I_i, Ts_prev, L_i, {damper_i}, {spring_i}, ...
                        x_i, xp_i, xpp_i, previous_i, []);
    
    previous_i = body_i;
    
    % Symbolics of the system
    sys.descrip.syms = [sys.descrip.syms, m_i, b_i, k_i];
    
    % Paramater of the system
    sys.descrip.model_params = [sys.descrip.model_params, 1, 0.1, 1];
    
    sys.descrip.bodies{end+1} = body_i;
end

sys.descrip.syms = [sys.descrip.syms, g];
sys.descrip.model_params = [sys.descrip.model_params, 9.8];

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Generalized coordinates
sys.kin.q = x_prev;
sys.kin.qp = xp_prev;
sys.kin.qpp = xpp_prev;

% Quasi-velocities
sys.kin.p = xp_prev;
sys.kin.pp = xpp_prev;

% External excitations
sys.descrip.Fq = zeros(n_mbk, 1);
sys.descrip.u = [];

% Sensors
sys.descrip.y = x_prev;

% State space representation
sys.dyn.states = [x_prev; xp_prev];

% Constraint condition
sys.descrip.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Decay time
m_num = sys.descrip.model_params(1);
b_num = sys.descrip.model_params(2);
T = m_num/b_num;

