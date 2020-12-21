if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

% The 'real' statement on end is important
% for inner simplifications
syms Ra Rs La k_b k_m ks Tpl Tf Beq Jeq sigma g L real;
syms x xp xpp u real;

% Paramater symbolics of the system
sys.descrip.syms = [Ra Rs La k_b k_m ks Tpl Tf Beq Jeq sigma];

% Paramater symbolics of the system
sys.descrip.model_params = [1.15, 1.5, 0.0015, 0.383, 0.383, ...
                            0.087, 0.396, 0.284, 0.0088, 0.0021 19];

model_params = sys.descrip.model_params;

% Gravity utilities
sys.descrip.gravity = [0; 0; 0];
sys.descrip.g = g;

% Body inertia
Inertia = diag(sym([Jeq, Jeq, Jeq]));

% Position relative to body coordinate system
Lg = zeros(3, 1);

% Bodies definition
T = {T3d(x, [0; 0; 1], [0; 0; 0])};

damper = build_damper(Beq, [0; 0; 0], [1; 0; 0]);
spring = build_spring(ks, [0; 0; 0], [1; 0; 0]);
block = build_body(0, Inertia, T, [0; 0; 0], {damper}, {spring}, ...
                   x, xp, xpp, struct(''), []);

sys.descrip.bodies = {block};

% Generalized coordinates
sys.kin.q = x;
sys.kin.qp = xp;
sys.kin.qpp = xpp;

% External excitations
s_f = 2/(1+exp(-sigma*xp)) - 1;
sys.descrip.Fq = (k_m/Ra)*(-k_b*xp + u) + Tf*s_f - Tpl;
sys.descrip.u = u;

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = x;

% State space representation
sys.descrip.states = [x; xp];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);