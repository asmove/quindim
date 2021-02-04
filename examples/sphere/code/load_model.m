if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

syms g f_phi f_th;

% Body 1
syms m R real;
syms x y th phi real;
syms xp yp thp phip real;
syms xpp ypp thpp phipp real;

sys.descrip.latex_origs = {{'xpp'}, {'\mathrm{xp}'}, {'ypp'}, {'\mathrm{yp}'}, ...
                           {'thpp'}, {'thp'}, {'\mathrm{th}'}, ...
                           {'\mathrm{phipp}'}, {'\mathrm{phip}'}, {'\mathrm{phi}'}, ...
                           {'\mathrm{p1}'}, {'\mathrm{p2}'}, {'\mathrm{p3}'}};

sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', '\ddot{y}', '\dot{y}', ...                          
                          '\ddot{\theta}', '\dot{\theta}', '\theta', ...
                          '\ddot{\phi}', '\dot{\phi}', '\phi', ...
                          '\, \mathrm{v}', '\omega_{\theta}', '\, \mathrm{\omega_{\phi}}'};


Is = sym('I', [3, 1], 'real');
I = diag(Is);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x; y; R]);
T2 = T3d(th, [0; 0; 1], [0; 0; 0]);
T3 = T3d(phi, [0; 1; 0], [0; 0; 0]);
Ts = {T1, T2, T3};

% CG position relative to body coordinate system
L = [0; 0; 0];

% Generalized coordinates
sys.kin.q = [x; y; th; phi];
sys.kin.qp = [xp; yp; thp; phip];
sys.kin.qpp = [xpp; ypp; thpp; phipp];

% Previous body
previous = struct('');

sphere = build_body(m, I, Ts, L, {}, {}, ...
                   sys.kin.q, sys.kin.qp, sys.kin.qpp, ...
                   previous, []);
sys.descrip.bodies = {sphere};

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Paramater symbolics of the system
sys.descrip.syms = [m, R, Is.', g];

% Penny data
m_num = 1;
R_num = 1;
sys.descrip.model_params = [m_num, R_num, ...
                            0.4*m_num*R_num^2, ...
                            0.4*m_num*R_num^2, ...
                            0.4*m_num*R_num^2, ...
                            9.8];

% External excitations
sys.descrip.Fq = [0; 0; f_th; f_phi];
sys.descrip.u = [f_phi; f_th];

% Constraint condition
sys.descrip.is_constrained = false;

% State space representation
sys.descrip.states = [x; y; th; phi];

% Kinematic and dynamic model
sys = kinematic_model(sys);

% Constraint condition
sys.descrip.is_constrained = true;

Jw = sys.dyn.Jw;

T12 = T1*T2;
T = T12*T3;
R12 = T12(1:3, 1:3);
R_ = T(1:3, 1:3);

v_cg = sys.descrip.bodies{1}.v_cg;
omega_ = omega(R_, sys.kin.q, sys.kin.qp);

constraints = v_cg + cross(omega_, R12*[0; 0; -R]);
sys.descrip.unhol_constraints = simplify_(constraints(1:2));

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);