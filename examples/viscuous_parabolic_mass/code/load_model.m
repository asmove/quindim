close all
clc

% The 'real' statement on end is important
% for inner simplifications
syms F;
syms x_pos xp xpp real;
syms y_pos yp ypp real;
syms m b g real;

% Paramater symbolics of the system
sys.descrip.syms = [m, b, g];

% Paramater symbolics of the system
sys.descrip.model_params = [1, 1, 9.8];

% Gravity utilities
sys.descrip.gravity = [0; -g; 0];
sys.descrip.g = g;

% Fields for plot
sys.descrip.latex_origs = {{'xpp'}, ...
                           {'\mathrm{xp}'}, ...
                           {'x_pos'}, ...
                           {'ypp'}, ...
                           {'\mathrm{yp}'}, ...
                           {'y_pos'}};

sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', 'x', ...
                          '\ddot{y}', '\dot{y}', 'y'};

% Body inertia
I = zeros(3, 3);

% Position relative to body coordinate system
L = [x_pos; x_pos^2; 0];

% Bodies definition
T = {T3d(0, [0, 0, 1].', [0; 0; 0])};

damper = build_damper(b, [0; 0; 0], [xp; yp; 0]);
block = build_body(m, I, T, L, {damper}, {}, ...
                   [x_pos; y_pos], [xp; yp], [xpp; ypp], struct(''), []);

sys.descrip.bodies = {block};

% Generalized coordinates
sys.kin.q = [x_pos; y_pos];
sys.kin.qp = [xp; yp];
sys.kin.qpp = [xpp; ypp];

% External excitations
sys.descrip.Fq = [0; 0];
sys.descrip.u = [];

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = [x_pos; y_pos];

% State space representation
sys.descrip.states = [x_pos; y_pos; xp; yp];

% Kinematic and dynamic model
sys.descrip.is_constrained = true;
sys.descrip.hol_constraints = {y_pos - x_pos^2};

sys = kinematic_model(sys);
sys.kin.Cs{1} = x_pos*sys.kin.C;
sys.kin.C = x_pos*sys.kin.C;

sys = dynamic_model(sys);
