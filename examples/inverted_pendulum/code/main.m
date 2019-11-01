% @Author: Bruno Peixoto
close all
clear all
clc

% The 'real' statement on end is important for inner simplifications
syms F m_b m_p Lg L b_b b_p g real;
syms x xp xpp real;
syms th thp thpp real;

% Body inertia
is_diag_b = true;
I_b = inertia_tensor('b', is_diag_b);

is_diag_p = true;
I_p = inertia_tensor('p', is_diag_p);

% Position relative to body coordinate system
Lg_ = [0; Lg; 0];

% Bodies transformations
T1 = T3d(0, [0; 0; 1], [x; 0; 0]);
T2 = T3d(pi/2 - th, [0; 0; 1], [0; 0; 0]);

% Body 1 and 2 related transformation matrices
T_bs = {T1};
T_ps = {T1, T2};

% Previous body - Inertial, in this case
previous_b = struct('');

params_b = [m_b, Lg];
params_p = [m_p, L, Lg];

% Damper and springs
damper_b = build_damper(b_b, [0; 0; 0], [xp; 0; 0]);

bar = build_body(m_b, I_b, T_bs, zeros(3, 1), {damper_b}, {}, ...
                  x, xp, xpp, previous_b, params_b);
              
previous_p = bar;

damper_p = build_damper(b_p, [0; 0; 0], [0; 0; thp]);
pendulum = build_body(m_p, I_p, T_ps, Lg_, {damper_p}, {}, ...
                      th, thp, thpp, previous_p, params_p);

Ib_1 = I_b(1, 1);
Ib_2 = I_b(2, 2);
Ib_3 = I_b(3, 3);
Ip_1 = I_p(1, 1);
Ip_2 = I_p(2, 2);
Ip_3 = I_p(3, 3);
              
% Without spring and damping
sys.descrip.syms = [m_b, m_p, L, Lg, ...
                    Ib_1, Ib_2, Ib_3, ...
                    Ip_1, Ip_2, Ip_3, ...
                    b_b, b_p, g];
m_b_n = 1;
m_p_n = 1;
L_n = 1;
Lg_n = 0.5;
Ib_1_n = 0.1;
Ib_2_n = 0.1;
Ib_3_n = 0.1;
Ip_1_n = 0.1;
Ip_2_n = 0.1;
Ip_3_n = 0.1;
b_b_n = 0;
b_p_n = 0;
g_n = 9.8;

sys.descrip.model_params = [m_b_n, m_p_n, L_n, Lg_n, ...
                            Ib_1_n, Ib_2_n, Ib_3_n, ...
                            Ip_1_n, Ip_2_n, Ip_3_n, ...
                            b_b_n, b_p_n, g_n];

sys.descrip.gravity = [0; -g; 0];
sys.descrip.g = g;

sys.descrip.bodies = {bar, pendulum};

% Generalized coordinates
sys.kin.q = [x; th];
sys.kin.qp = [xp; thp];
sys.kin.qpp = [xpp; thpp];

% Generalized coordinates
sys.kin.p = [xp; thp];
sys.kin.pp = [xpp; thpp];

% External excitations
sys.descrip.Fq = [F; 0];
sys.descrip.u = F;

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = [x; th];

% State space representation
sys.descrip.states = [th; x; thp; xp];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Initia conditions [m; m/s]
x0 = [0; pi/3; 0; 0];

% Time [s]
dt = 0.05;
tf = 5;
t = 0:dt:tf; 

% System modelling
sol = validate_model(sys, t, x0, 0);

x = t;
y = sol';

plot_info.titles = {'$x$', '$\theta$',  ...
                    '$\dot x$', '$\dot \theta$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$x$', '$\theta$', ...
                    '$\dot x$', '$\dot \theta$'};
plot_info.grid_size = [2, 2];

% States and energies plot
hfigs_states = my_plot(x, y, plot_info);
hfig_energies = plot_energies(sys, x, y);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');
saveas(hfigs_states, '../imgs/states', 'epsc'); 

