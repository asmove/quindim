if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

syms g tau_r tau_l;

% Body 1
syms m R L real;
syms x_pos y_pos theta threal;
syms xp yp thetap real;
syms xpp ypp thetapp real;

I = inertia_tensor('1', true);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x_pos; y_pos; 0]);
T2 = T3d(theta, [0; 0; 1], [0; 0; 0]);
Ts = {T1, T2};

% CG position relative to body coordinate system
Lg = [0; 0; 0];

% Generalized coordinates
sys.kin.q = [x_pos; y_pos; theta];
sys.kin.qp = [xp; yp; thetap];
sys.kin.qpp = [xpp; ypp; thetapp];

sys.descrip.latex_origs = {{'xpp'}, ...
                           {'\mathrm{xp}'}, ...
                           {'x_pos'}, ...
                           {'ypp'}, ...
                           {'\mathrm{yp}'}, ...
                           {'y_pos'}, ...
                           {'thetapp'}, ...
                           {'thetap'}, ...
                           {'\mathrm{theta}'}};
sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', 'x', ...
                          '\ddot{y}', '\dot{y}', 'y', ...                          
                          '\ddot{\theta}', ...
                          '\dot{\theta}', ...
                          '\theta'};

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
sys.descrip.syms = [m, R, diag(I).', g, L];

% Penny data
% https://www.neobotix-roboter.de/produkte/mobile-roboter/mobiler-roboter-mp-500
m_num = 1;
R_num = 33e-3;
L_num = 138e-3;
W_num = 178e-3;
d_cg = 33e-3;

sys.descrip.model_params = [m_num, R_num, ...
                            0, 0, m_num*(L_num^2 + W_num^2)/3 + ...
                            m_num*d_cg^2, 9.8, L_num];

% External excitations
R = sys.descrip.syms(2);
L = sys.descrip.syms(end);
U = [cos(theta)/R, cos(theta)/R; sin(theta)/R, sin(theta)/R; L/R, -L/R];
sys.descrip.u = [tau_r; tau_l];
sys.descrip.Fq = U*sys.descrip.u;

% State space representation
sys.descrip.states = [x_pos; y_pos; theta];

% Constraint condition
sys.descrip.is_constrained = true;
sys.descrip.unhol_constraints = xp*sin(theta) - yp*cos(theta);

% Kinematic and dynamic model
sys = kinematic_model(sys);

sys.kin.C(:, 1) = sin(theta)*sys.kin.C(:, 1);
sys.kin.Cs{1} = sys.kin.C;

sys = dynamic_model(sys);