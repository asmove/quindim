% Double Single example
% @Author: Bruno Peixoto

close all
clear all
clc

% The 'real' statement on end is important for inner simplifications
syms tau m0 m1 L0g L1g L0 L1 b g real;
syms th0 th0p th0pp real;
syms th1 th1p th1pp real;

% Body inertia
is_diag1 = true;
I0 = inertia_tensor('0', is_diag1);

is_diag2 = true;
I1 = inertia_tensor('1', is_diag2);

% Position relative to body coordinate system
L0g_ = [0; L0g; 0];
L1g_ = [0; 0; L1g];

% Bodies transformations
T1 = T3d(th0, [0; 0; 1], [0; 0; 0]);
T2 = T3d(0, [0; 0; 1], [0; L0; 0]);
T3 = T3d(pi/2 + th1, [0; 1; 0], [0; 0; 0]);

% Body 1 and 2 related transformation matrices
T0s = {T1};
T1s = {T1, T2, T3};

% Previous body - Inertial, in this case
previous1 = struct('');

params1 = [m0, L0, L0g];
params2 = [m1, L1, L1g];

% Damper and springs
damper = build_damper(b, [0; 0; 0], [0; th1p; 0]);

bar1 = build_body(m0, I0, T0s, L0g_, {}, {}, ...
                  th0, th0p, th0pp, previous1, params1);
              
previous2 = bar1;
              
bar2 = build_body(m1, I1, T1s, L1g_, damper, {}, ...
                  th1, th1p, th1pp, previous2, params2);

I0_1 = I0(1, 1);
I0_2 = I0(2, 2);
I0_3 = I0(3, 3);
I1_1 = I1(1, 1);
I1_2 = I1(2, 2);
I1_3 = I1(3, 3);
              
% Without spring and damping
sys.descrip.syms = [m0, L0, L0g, ...
                    m1, L1, L1g, ...
                    I0_1, I0_2, I0_3, ...
                    I1_1, I1_2, I1_3, ...
                    b, g];
sys.descrip.model_params = [1, 1, 1, 1, 1, 1, ...
                            1, 1, 1, 1, 1, 1, ... 
                            0, 9.8];

sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

sys.descrip.bodies = [bar1, bar2];

% Generalized coordinates
sys.kin.q = [th0; th1];
sys.kin.qp = [th0p; th1p];
sys.kin.qpp = [th0pp; th1pp];

% Generalized coordinates
sys.kin.p = [th0p; th1p];
sys.kin.pp = [th0pp; th1pp];

% External excitations
sys.descrip.Fq = [tau; 0];
sys.descrip.u = tau;

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = [th0; th1];

% State space representation
sys.descrip.states = [th0; th1; th0p; th1p];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Initia conditions [m; m/s]
x0 = [0; pi/3; 0; 0];

% Time [s]
dt = 0.001;
tf = 5;
t = 0:dt:tf; 

% System modelling
sol = validate_model(sys, t, x0, 0);

x = sol.x;
y = sol.y.';

plot_info.titles = {'$\theta_0$', '$\theta_1$', ...
                    '$\dot \theta_0$', '$\dot \theta_1$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$\theta_0$', '$\theta_1$', ...
                    '$\dot \theta_0$', '$\dot \theta_1$'};
plot_info.grid_size = [2, 2];

% States and energies plot
hfigs_states = my_plot(x, y, plot_info);
hfig_energies = plot_energies(sys, x, y);

% Energies
saveas(hfig_energies, '../images/energies', 'epsc');

for j = 1:length(hfigs_states)
   saveas(hfigs_states(j), ['../images/states', num2str(i)], 'epsc'); 
end
