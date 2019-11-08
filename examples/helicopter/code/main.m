% @Author: Bruno Peixoto
if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

% The 'real' statement on end is important for inner simplifications
syms F_th F_phi m Lg_x Lg_y Lg_z L b_th b_phi g real;
syms th thp thpp real;
syms phi phip phipp real;

% Body inertia
is_diag_b = true;
I = inertia_tensor('b', is_diag_b);

% Position relative to body coordinate system
Lg_ = [Lg_x; Lg_y; Lg_z];

% Bodies transformations
T1 = T3d(th, [0; 0; 1], [0; 0; 0]);
T2 = T3d(phi, [1; 0; 0], [0; 0; 0]);

% Body 1 and 2 related transformation matrices
Ts = {T1, T2};

% Previous body - Inertial, in this case
previous = struct('');

params = [m Lg_y Lg_z L b_th b_phi g];

% Damper and springs
damper_th = build_damper(b_th, [0; 0; 0], [0; 0; thp]);
damper_phi = build_damper(b_phi, [0; 0; 0], [0; 0; phip]);

dampers = {damper_th, damper_phi};

Lg_ = [Lg_x; Lg_y; Lg_z];

bar = build_body(m, I, Ts, Lg_, dampers, {}, ...
                  [th, phi], [thp, phip], [thpp, phipp], ...
                  previous, params);

I_1 = I(1, 1);
I_2 = I(2, 2);
I_3 = I(3, 3);
              
% Without spring and damping
sys.descrip.syms = [m I_1 I_2 I_3 Lg_x Lg_y Lg_z L b_th b_phi g];

m_n = 1;
I_1_n = 0.1;
I_2_n = 0.1;
I_3_n = 0.1;
Lg_x_n = 1;
Lg_y_n = 1;
Lg_z_n = 1;
L_n = 2;
b_th_n = 0.1;
b_phi_n = 0.1;
g_n = 9.8;

sys.descrip.model_params = [m_n I_1_n I_2_n I_3_n ...
                            Lg_x_n Lg_y_n Lg_z_n L_n b_th_n b_phi_n g_n];

sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

sys.descrip.bodies = {bar};

% Generalized coordinates
sys.kin.q = [th; phi];
sys.kin.qp = [thp; phip];
sys.kin.qpp = [thpp; phipp];

% Generalized coordinates
sys.kin.p = [th; phi];
sys.kin.pp = [thp; phip];

% External excitations
sys.descrip.Fq = [F_th; F_phi];
sys.descrip.u = [F_th; F_phi];

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = [th; phi];

% State space representation
sys.descrip.states = [th; phi; thp; phip];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Initia conditions [m; m/s]
x0 = [pi/3; pi/3; 0; 0];

% Time [s]
dt = 0.05;
tf = 5;
t = 0:dt:tf; 

% System modelling
u0 = [0; 0];
sol = validate_model(sys, t, x0, u0);

x = t;
y = sol';

plot_info.titles = {'$\theta$', '$\phi$', ...
                    '$\dot \theta$', '$\dot \phi$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$\theta$', '$\phi$', ...
                    '$\dot \theta$', '$\dot \phi$'};
plot_info.grid_size = [2, 2];

% States and energies plot
hfigs_states = my_plot(x, y, plot_info);
hfig_energies = plot_energies(sys, x, y);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');
saveas(hfigs_states, '../imgs/states', 'epsc'); 

