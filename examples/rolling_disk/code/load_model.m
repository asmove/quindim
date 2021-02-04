if(~exist('CLEAR_ALL'))
    clear all;
else
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

syms g f_phi f_th;

% Body 1
syms m R real;
syms x y theta phi real;
syms xp yp thetap phip real;
syms xpp ypp thetapp phipp real;

Is = sym('I', [3, 1], 'real');
I = diag(Is);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x; y; R]);
T2 = T3d(theta, [0; 0; 1], [0; 0; 0]);

Ts = {T1, T2};

% CG position relative to body coordinate system
L = [0; 0; 0];

% Generalized coordinates
sys.kin.q = [x; y; theta; phi];
sys.kin.qp = [xp; yp; thetap; phip];
sys.kin.qpp = [xpp; ypp; thetapp; phipp];

% Previous body
previous = struct('');

wheel = build_body(m, I, Ts, L, {}, {}, ...
                   sys.kin.q, sys.kin.qp, sys.kin.qpp, ...
                   previous, []);

wheel = update_omega(wheel, wheel.R, [0; phip; 0]);

sys.descrip.bodies = {wheel};

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

sys.descrip.latex_origs = {{'xpp'}, ...
                           {'\mathrm{xp}'}, ...
                           {'x_pos'}, ...
                           {'ypp'}, ...
                           {'\mathrm{yp}'}, ...
                           {'y_pos'}, ...
                           {'thetapp'}, ...
                           {'thetap'}, ...
                           {'\mathrm{theta}'}, ...
                           {'\mathrm{phipp}'}, ...
                           {'\mathrm{phip}'}, ...
                           {'\mathrm{phi}'}, ...
                           {'\mathrm{p1}'}, ...
                           {'\mathrm{p2}'}, ...
                           {'\mathrm{p3}'}};

sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', 'x', ...
                          '\ddot{y}', '\dot{y}', 'y', ...                          
                          '\ddot{\theta}', ...
                          '\dot{\theta}', ...
                          '\theta', ...
                          '\ddot{\phi}', ...
                          '\dot{\phi}', ...
                          '\phi', ...
                          '\, \mathrm{v}', ...
                          '\omega_{\theta}', ...
                          '\, \mathrm{\omega_{\phi}}'};

% Paramater symbolics of the system
sys.descrip.syms = [m, R, Is.', g];

% Penny data
m_num = 7;
R_num = 0.65;
% m_num = 0.4;
% R_num = 0.05;
sys.descrip.model_params = [m_num, R_num, ...
                            m_num*R_num^2/2, ...
                            m_num*R_num^2/4, ...
                            m_num*R_num^2/2, ...
                            9.8];

% External excitations
sys.descrip.Fq = [0; 0; f_th; f_phi];
sys.descrip.u = [f_phi; f_th];

% State space representation
sys.descrip.states = [x; y; theta; phi];

% Constraint condition
sys.descrip.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);

T12 = T1*T2;
R12 = T12(1:3, 1:3);

v_cg = simplify_(sys.descrip.bodies{1}.v_cg);

v_contact = v_cg + cross(wheel.omega, R12*[0; 0; -R]);

u = R12*[1; 0; 0];
w = R12*[0; 1; 0];
constraints = {simplify_(dot(v_contact, w)), ...
               simplify_(dot(v_contact, u))};

sys.descrip.is_constrained = true;
sys.descrip.unhol_constraints = constraints;

% Kinematic and dynamic model
sys = kinematic_model(sys);
[~, cos_psi] = numden(sys.kin.C(1, 1));
sys.kin.C(:, 1) = sys.kin.C(:, 1)*cos_psi;
sys.kin.C(:, 2) = sys.kin.C(:, 2)*cos_psi;

sys = dynamic_model(sys);