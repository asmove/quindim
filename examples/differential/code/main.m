% Differential robot
% @Author: Bruno Peixoto

if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

% The 'real' statement on end is important for inner simplifications
syms tau_r tau_l real; 
syms m_r m_l m_c m_f m_s real;
syms R R_f g L_c Lg_f_y L L_f L_s real;
syms b_r b_l b_f b_s real;

syms w real;

syms phi_r phip_r phipp_r real;
syms phi_l phip_l phipp_l real;
syms phi_s phip_s phipp_s real;
syms beta betap betapp real;

syms x xp xpp real;
syms y yp ypp real;
syms th thp thpp real;

% Chassi
is_diag_c = true;
I_c = inertia_tensor('_c', is_diag_c);

% Right wheel
is_diag_r = true;
I_r = inertia_tensor('_r', is_diag_r);

% Left wheel
is_diag_l = true;
I_l = inertia_tensor('_l', is_diag_l);

% Front wheel support 
is_diag_f = true;
I_f = inertia_tensor('_f', is_diag_f);

is_diag_s = true;
I_s = inertia_tensor('_s', is_diag_s);

% Position relative to body coordinate system
Lg_c = [0; L_c; 0];
Lg_r = [0; 0; 0];
Lg_l = [0; 0; 0];
Lg_f = [0; Lg_f_y; 0];
Lg_s = [0; 0; 0];

% Bodies transformations
T0 = T3d(th, [0; 0; 1], [x; y; 0]);
T1 = T3d(phi_r, [0; 1; 0], [0; L/2; 0]);
T2 = T3d(phi_l, [0; 1; 0], [0; -L/2; 0]);
T3 = T3d(0, [0; 0; 1], [L_f; 0; 0]);
T4 = T3d(beta, [0; 0; 1], [0; 0; 0]);
T5 = T3d(phi_s, [0; 1; 0], [0; 0; -L_s]);

% Body 1 and 2 related transformation matrices
Ts_c = {T0};
Ts_r = {T0};
Ts_l = {T0};
Ts_f = {T0, T4};
Ts_s = {T0, T4};

% Previous body - Inertial, in this case
params_c = [m_c, diag(I_c)', L, L_c];
params_r = [m_r, diag(I_r)'];
params_l = [m_l, diag(I_l)'];
params_f = [m_f, diag(I_f)'];
params_s = [m_s, diag(I_s)'];

% Dampers and springs
damper_r = build_damper(b_r, [0; 0; 0], [0; phip_r; 0]);
damper_l = build_damper(b_l, [0; 0; 0], [0; phip_r; 0]);
damper_f = build_damper(b_f, [0; 0; 0], [0; beta; 0]);
damper_s = build_damper(b_s, [0; 0; 0], [0; phip_s; 0]);

% Chassi
previous_c = struct('');

states_c = [x, y, th].';
speed_c = [xp, yp, thp].';
accel_c = [xpp, ypp, thpp].';

params_c = [];

chassi = build_body(m_c, I_c, Ts_c, Lg_c, {}, {}, ...
                    states_c, speed_c, accel_c, ...
                    previous_c, params_c);

% Right wheel
previous_r = chassi;

states_r = [x, y, th, phi_r].';
speed_r = [xp, yp, thp, phip_r].';
accel_r = [xpp, ypp, thpp, phipp_r].';

params_r = [];

wheel_r = build_body(m_r, I_r, Ts_r, Lg_r, {damper_r}, {}, ...
                     states_r, speed_r, accel_r, ...
                     previous_r, params_r);

% Left wheel
previous_l = chassi;

states_l = [x, y, th, phi_l].';
speed_l = [xp, yp, thp, phip_l].';
accel_l = [xpp, ypp, thpp, phipp_l].';

wheel_l = build_body(m_r, I_r, Ts_l, Lg_r, {damper_l}, {}, ...
                     states_l, speed_l, accel_l, ...
                     previous_l, params_l);

% Frontal support - Robot
previous_f = chassi;

states_f = [x, y, th, beta].';
speed_f = [xp, yp, thp, betap].';
accel_f = [xpp, ypp, thpp, betapp].';

front_support = build_body(m_f, I_f, Ts_f, Lg_f, {damper_f}, {}, ...
                           states_f, speed_f, accel_f, ...
                           previous_f, params_f);

% Support wheel (Castor wheel)
previous_s = front_support;

states_s = [x, y, th, beta, phi_s].';
speed_s = [xp, yp, thp, betap, phip_s].';
accel_s = [xpp, ypp, thpp, betapp, phipp_s].';

wheel_s = build_body(m_s, I_s, Ts_s, Lg_s, {damper_s}, {}, ...
                     states_s, speed_s, accel_s, ...
                     previous_s, params_s);
               
sys.descrip.syms = [m_r, m_l, m_c, m_f, m_s, ...
                    R, R_f, g, L_c, w, Lg_f_y, ...
                    L, L_f, L_s, ...
                    b_r, b_l, b_f, b_s, ...
                    diag(I_c).', diag(I_r).', ...
                    diag(I_l).', diag(I_f).', diag(I_s).'];

m_r_n = 1;
m_l_n = 1;
m_c_n = 1;
m_f_n = 1;
m_s_n = 1;
R_n = 1;
R_f_n = 1;
g_n = 1;
L_c_n = 1;
Lg_f_y_n = 1;
L_n = 1;
L_f_n = 1;
L_s_n = 1;
w_n = 0.5;
b_r_n = 0;
b_l_n = 0;
b_f_n = 0;
b_s_n = 0;
Is_c = 0.1*ones(1, 3);
Is_r = 0.1*ones(1, 3);
Is_l = 0.1*ones(1, 3);
Is_f = 0.1*ones(1, 3);
Is_s = 0.1*ones(1, 3);

sys.descrip.model_params = [m_r_n, m_l_n, m_c_n, m_f_n, m_s_n, ...
                            R_n, R_f_n, g_n, L_c_n, w_n, ...
                            Lg_f_y_n, L_n, L_f_n, L_s_n, ...
                            b_r_n, b_l_n, b_f_n, b_s_n, ...
                            Is_c, Is_r, Is_l, Is_f, Is_s];

sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

sys.descrip.bodies = {chassi, wheel_r, wheel_l, front_support, wheel_s};

% Generalized coordinates
sys.kin.q = [x; y; th; beta; phi_r; phi_l; phi_s];
sys.kin.qp = [xp; yp; thp; betap; phip_r; phip_l; phip_s];
sys.kin.qpp = [xpp; ypp; thpp; betapp; phipp_r; phipp_l; phipp_s];

% Generalized coordinates
sys.kin.p = sym('p_%d', [4, 1]);
sys.kin.pp = sym('pp_%d', [4, 1]);

% External excitations
sys.descrip.Fq = [0; 0; 0; tau_r; tau_l; 0; 0];
sys.descrip.u = [tau_r; tau_l];

% Constraint condition
sys.descrip.is_constrained = true;

% Sensors
sys.descrip.y = [phi_r; phi_l; phi_s];

% State space representation
sys.descrip.states = [sys.kin.q; sys.kin.p];

T_f = sys.descrip.bodies{4}.T;
T_r = sys.descrip.bodies{2}.T;
T_l = sys.descrip.bodies{3}.T;
T_s = sys.descrip.bodies{5}.T;

R0f = T_f(1:3, 1:3);
R0r = T_r(1:3, 1:3);
R0l = T_l(1:3, 1:3);
R0s = T_s(1:3, 1:3);

omega_c = omega(R0r, sys.kin.q, sys.kin.qp);
omega_f = omega(R0l, sys.kin.q, sys.kin.qp);
omega_r = omega(R0r, sys.kin.q, sys.kin.qp) + R0r*[0; phip_r; 0];
omega_l = omega(R0l, sys.kin.q, sys.kin.qp) + R0l*[0; phip_l; 0];
omega_s = omega(R0s, sys.kin.q, sys.kin.qp) + R0s*[0; phip_s; 0];

v_gr = [xp; yp; 0] + cross(omega_c, [0; L; 0]);
v_gl = [xp; yp; 0] + cross(omega_c, [0; -L; 0]);

v_f = [xp; yp; 0] + cross(omega_c, [L_f; 0; 0]);
v_s = v_f + cross(omega_f, [0; 0; -L_s]);

v_r = v_gr + cross(omega_r, [0; 0; -R]);
v_l = v_gl + cross(omega_l, [0; 0; -R]);
v_c = v_s + cross(omega_s, [0; 0; -R]);

u_r = R0r*[1; 0; 0];
u_l = R0l*[1; 0; 0];
u_s = R0s*[1; 0; 0];

w_r = R0r*[0; 1; 0];
w_l = R0l*[0; 1; 0];
w_s = R0s*[0; 1; 0];

radius_1 = L_f*cos(beta)/sin(beta);
radius_s = radius_1/cos(beta);
radius_g = sqrt(L_c^2 + radius_1^2);
radius_r = radius_1 + w/2;
radius_l = radius_1 - w/2;

T = sys.descrip.bodies{1}.T;
p_cg = sys.descrip.bodies{1}.p_cg;
p_g = T*[p_cg; 1];
p_g = p_g(1:3);

q = sys.kin.q;
qp = sys.kin.qp;
v_cg = dvecdt(p_g, q, qp);
v_cg = v_cg(1:3);

cos_deltag = L_c/radius_g;
sin_deltag = radius_1/radius_g;

orient_g = [cos_deltag; sin_deltag; 0];

v_g = simplify(dot(v_cg, orient_g));

sys.descrip.unhol_constraints = simplify_([dot(v_l, u_l); ...
                                           dot(v_l, w_l); ...
                                           simplify_((phip_r*R*radius_g - v_g*radius_r)*sin(beta)); ...
                                           simplify_((phip_l*radius_r - phip_r*radius_l)*sin(beta)); ...
                                           simplify_((phip_s*radius_r - phip_r*radius_s)*sin(beta))]);

% Kinematic and dynamic model
sys = kinematic_model(sys);

% sys.kin.C(:, 3) = sin(phi_r)*sys.kin.C(:, 3);
% sys.kin.Cs = sys.kin.C;

sys = dynamic_model(sys);

% Initial conditions [m; m/s]
x0 = [0; 0; 0; 0; 0; 0; 0; 1; 1];

% Time [s]
dt = 0.01;
tf = 5;
t = 0:dt:tf; 

u_func = @(t, x) zeros(length(sys.descrip.u), 1);

% Model loading
model_name = 'simple_model';

gen_scripts(sys, model_name);

load_system(model_name);

simMode = get_param(model_name, 'SimulationMode');
set_param(model_name, 'SimulationMode', 'normal');

cs = getActiveConfigSet(model_name);
mdl_cs = cs.copy;
set_param(mdl_cs, 'SolverType','Variable-step', ...
                  'SaveState','on','StateSaveName','xoutNew', ...
                  'SaveOutput','on','OutputSaveName','youtNew');

save_system();
              
t0 = tic();
simOut = sim(model_name, mdl_cs);
toc(t0);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
x = [q, p];

states = simOut.states.signals.values;
q_speeds = simOut.q_speeds.signals.values;
t = simOut.tout;

plot_info.titles = {'', '', '', '', '', '', '', '', ''};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$x$', '$y$', '$\theta$', ...
                    '$\theta_1$', '$\theta_2$', '$\theta_3$', ...
                    '$p_1$', '$p_2$', '$p_3$'};
plot_info.grid_size = [3, 3];

% States and energies plot
hfigs_states = my_plot(t, x, plot_info);
% hfig_energies = plot_energies(sys, t, x);
hfig_consts = plot_constraints(sys, t, x);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');

for j = 1:length(hfigs_states)
   saveas(hfigs_states(j), ['../imgs/states', num2str(i)], 'epsc'); 
end
