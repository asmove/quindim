if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

syms g f_phi;

% Body 1
syms m_b m_w R Lg g real;
syms phi th r real;
syms phip thp rp real;
syms phipp thpp rpp real;

sys.descrip.latex_origs = {{'\mathrm{phi}'}, ...
                           {'\mathrm{thp}'}, ...
                           {'\mathrm{rp}'}};

sys.descrip.latex_text = {'\phi', '\dot{\theta}', '\dot{r}'};

I_b = sym('I_b_', [3, 1]);
I_b = diag(I_b);

I_w = sym('I_w_', [3, 1]);
I_w = diag(I_w);

% Rotations to body
T1 = T3d(phi, [0; 0; 1], [0; 0; 0]);
T2 = T3d(th, [0; 0; 1], [r; R; 0]);
T_b = {T1};
T_w = {T1, T2};

% CG position of the bar to body coordinate system
L = [Lg; 0; 0];

% Generalized coordinates
sys.kin.q = [phi; th; r];
sys.kin.qp = [phip; thp; rp];
sys.kin.qpp = [phipp; thpp; rpp];

% Previous body
previous = struct('');

bar = build_body(m_b, I_b, T_b, L, {}, {}, ...
                 phi, phip, phipp, previous, []);
               
wheel = build_body(m_w, I_w, T_w, zeros(3, 1), {}, {}, ...
                   th, thp, thpp, bar, []);
               
sys.descrip.bodies = {bar, wheel};

% Gravity utilities
sys.descrip.gravity = [0; -g; 0];
sys.descrip.g = g;

% Paramater symbolics of the system
sys.descrip.syms = [m_b, m_w, R, Lg, diag(I_b).', diag(I_w).', g];

% Penny data
sys.descrip.model_params = ones(1, length(sys.descrip.syms));

% External excitations
sys.descrip.Fq = [f_phi; 0; 0];
sys.descrip.u = f_phi;

% State space representation
sys.descrip.states = [phi; th];

% Constraint condition
sys.descrip.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);

% Velocity from wheel equal to bar
T_b = sys.descrip.bodies{1}.T;
T_bw = sys.descrip.bodies{2}.T;
R_b = T_b(1:3, 1:3);
R_bw = T_bw(1:3, 1:3);

v_bar_contact = r*dvecdt(T_b(1:3, 1), sys.kin.q, sys.kin.qp);

p_w = point(T_b, [r; R; 0]);
v_wheel_center = dvecdt(p_w, sys.kin.q, sys.kin.qp);
omega_w = omega(R_bw, sys.kin.q, sys.kin.qp);
v_wheel_contact = v_wheel_center + cross(omega_w, R_b*[0; -R; 0]);

sys.descrip.is_constrained = true;
constraints = v_wheel_contact - v_bar_contact;
sys.descrip.unhol_constraints = {simplify_(constraints(1:2))};

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);