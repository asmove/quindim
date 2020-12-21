if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

syms g F_x F_y;

% Body 1
syms m R L real;
syms x_pos y_pos threal;
syms xp yp real;
syms xpp ypp real;

I = inertia_tensor('1', true);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x_pos; y_pos; 0]);
Ts = {T1};

% CG position relative to body coordinate system
Lg = [0; 0; 0];

% Generalized coordinates
sys.kin.q = [x_pos; y_pos];
sys.kin.qp = [xp; yp];
sys.kin.qpp = [xpp; ypp];

sys.descrip.latex_origs = {{'xpp'}, ...
                           {'\mathrm{xp}'}, ...
                           {'x_pos'}, ...
                           {'ypp'}, ...
                           {'\mathrm{yp}'}, ...
                           {'y_pos'}};
sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', 'x', ...
                          '\ddot{y}', '\dot{y}', 'y'};

% Previous body
previous = struct('');

robot = build_body(m, I, Ts, Lg, {}, {}, ...
                   sys.kin.q, sys.kin.qp, sys.kin.qpp, ...
                   previous, []);
sys.descrip.bodies = {robot};

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Paramater symbolics of the system
sys.descrip.syms = [m, diag(I).', g, L];

m_num = 1;
L_num = 0.2;
sys.descrip.model_params = [m_num, m_num*L_num^2/2, ...
                            m_num*L_num^2/4, ...
                            m_num*L_num^2/2, ...
                            9.8, ...
                            L_num];

% External excitations
L = sys.descrip.syms(end);
sys.descrip.u = [F_x; F_y];
sys.descrip.Fq = [F_x; F_y];

% State space representation
sys.descrip.states = [x_pos; y_pos];

% Constraint condition
sys.descrip.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);