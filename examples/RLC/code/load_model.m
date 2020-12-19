if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

% The 'real' statement on end is important
% for inner simplifications
syms u Q I Ip real;
syms L R k g real;

% Paramater symbolics of the system
sys.descrip.syms = [L, R, k, g];

% Paramater symbolics of the system
sys.descrip.model_params = [0.5, 19e-3, 1/25e-6, 9.8];
% sys.descrip.model_params = [1000, 1, 1/25e-6, 9.8];
model_params = sys.descrip.model_params;

% Gravity utilities
sys.descrip.gravity = [0; 0; 0];
sys.descrip.g = g;

% Body inertia
Inertia = zeros(3, 3);

% Position relative to body coordinate system
Lg = zeros(3, 1);

% Bodies definition
T = {T3d(0, [0, 0, 1].', [Q; 0; 0])};

resistor = build_damper(R, [0; 0; 0], [I; 0; 0]);
capacitor = build_spring(k, [0; 0; 0], [Q; 0; 0]);
block = build_body(L, Inertia, T, Lg, {resistor}, {capacitor}, ...
                   Q, I, Ip, struct(''), []);

sys.descrip.bodies = {block};

% Generalized coordinates
sys.kin.q = Q;
sys.kin.qp = I;
sys.kin.qpp = Ip;

% External excitations
sys.descrip.Fq = u;
sys.descrip.u = u;

% External excitations
sys.descrip.Fq = u;
sys.descrip.u = u;

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = I;

% State space representation
sys.descrip.states = [Q; I];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);
