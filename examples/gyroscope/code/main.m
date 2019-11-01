% @Author: Bruno Peixoto
close all
clear all
clc

% The 'real' statement on end is important for inner simplifications
syms m_a m_b m_c m_d;
syms b_a b_b b_c b_d;

syms g;

syms T1 T2;
syms tha thap thapp real;
syms thb thbp thbpp real;
syms thc thcp thcpp real;
syms thd thdp thdpp real;

% Body inertia
I_a = inertia_tensor('a', true);
I_b = inertia_tensor('b', true);
I_c = inertia_tensor('c', true);
I_d = inertia_tensor('d', true);

% Position relative to body coordinate system
Lg_ = [0; 0; 0];

% Bodies transformations
Tnd = T3d(thd, [0; 0; 1], [0; 0; 0]);
Tdc = T3d(thc, [0; 1; 0], [0; 0; 0]);
Tcb = T3d(thb, [1; 0; 0], [0; 0; 0]);
Tba = T3d(tha, [1; 0; 0], [0; 0; 0]);

T_d = {Tnd};
T_c = {Tnd, Tcb};
T_b = {Tnd, Tdc, Tcb};
T_a = {Tnd, Tdc, Tcb, Tba};

% Previous body - Inertial, in this case
previous = struct('');

params_a = [m_a, diag(I_a).' b_a];
params_b = [m_b, diag(I_b).' b_b];
params_c = [m_c, diag(I_c).' b_c];
params_d = [m_d, diag(I_d).' b_d];

% Damper and springs
damper_a = build_damper(b_a, [0; 0; 0], [0; 0; thap]);
damper_b = build_damper(b_b, [0; 0; 0], [0; 0; thbp]);
damper_c = build_damper(b_c, [0; 0; 0], [0; 0; thcp]);
damper_d = build_damper(b_d, [0; 0; 0], [0; 0; thdp]);

dampers = {damper_a, damper_b, damper_c, damper_d};
             
frame_a = build_body(m_a, I_a, T_a, zeros(3, 1), {damper_a}, {}, ...
                  thb, thbp, thbpp, struct(''), params_a);

frame_b = build_body(m_b, I_b, T_b, zeros(3, 1), {damper_b}, {}, ...
                  thd, thdp, thdpp, frame_a, params_b);
              
frame_c = build_body(m_c, I_c, T_c, zeros(3, 1), {damper_c}, {}, ...
                  thc, thcp, thcpp, frame_b, params_c);
              
frame_d = build_body(m_a, I_a, T_d, zeros(3, 1), {damper_d}, {}, ...
                     thd, thdp, thdpp, frame_c, params_d);
              
% Without spring and damping
sys.descrip.syms = [params_a, params_b, params_c, params_d, g];

m_a_n = 1;
m_b_n = 1;
m_c_n = 1;
m_d_n = 1;

Ia_1_n = 0.1;
Ia_2_n = 0.1;
Ia_3_n = 0.1;

Ib_1_n = 0.1;
Ib_2_n = 0.1;
Ib_3_n = 0.1;

Ic_1_n = 0.1;
Ic_2_n = 0.1;
Ic_3_n = 0.1;

Id_1_n = 0.1;
Id_2_n = 0.1;
Id_3_n = 0.1;

b_a_n = 0.1;
b_b_n = 0.1;
b_c_n = 0.1;
b_d_n = 0.1;

g_n = 9.8;

sys.descrip.model_params = [m_a_n Ia_1_n Ia_2_n Ia_3_n b_a_n , ...
                            m_b_n Ib_1_n Ib_2_n Ib_3_n b_b_n , ...
                            m_c_n Ic_1_n Ic_2_n Ic_3_n b_c_n , ...
                            m_d_n Id_1_n Id_2_n Id_3_n b_d_n, ...
                            g_n];

sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

sys.descrip.bodies = {frame_d, frame_c, frame_b, frame_a};

% Generalized coordinates
sys.kin.q = [tha; thb; thc; thd];
sys.kin.qp = [thap; thbp; thcp; thdp];
sys.kin.qpp = [thapp; thbpp; thcpp; thdpp];

% Generalized coordinates
sys.kin.p = sys.kin.qp;
sys.kin.pp = sys.kin.qpp;

% External excitations
sys.descrip.Fq = [0; 0; T1; T2];
sys.descrip.u = [T1; T2];

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = [tha; thb; thc; thd];

% State space representation
sys.descrip.states = [tha; thb; thc; thd; thap; thbp; thcp; thdp];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Initia conditions [m; m/s]
x0 = [pi/4; pi/4; pi/4; pi/4; ...
      1; 1; 1; 1];

% Time [s]
dt = 0.05;
tf = 5;
t = 0:dt:tf; 

% System modelling
[~, m] = size(sys.dyn.Z);
u0 = zeros(m, 1);
sol = validate_model(sys, t, x0, u0);

x = t;
y = sol';

plot_info.titles = {'$\theta_a$', '$\theta_b$', ...
                    '$\theta_c$', '$\theta_d$', ...
                    '$\dot \theta_a$', '$\dot \theta_b$', ...
                    '$\dot \theta_c$', '$\dot \theta_d$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$\theta_a$', '$\theta_b$', ...
                    '$\theta_c$', '$\theta_d$', ...
                    '$\dot \theta_a$', '$\dot \theta_b$', ...
                    '$\dot \theta_c$', '$\dot \theta_d$'};
plot_info.grid_size = [2, 2];

% States and energies plot
hfigs_states = my_plot(x, y, plot_info);
hfig_energies = plot_energies(sys, x, y);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');
saveas(hfigs_states, '../imgs/states', 'epsc'); 

