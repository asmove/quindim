% Author: Bruno Peixoto
% Date: 08/01/19

if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

syms g f_psi f_phi f_th;

% Body 1
syms m R real;
syms x y th phi psi real;
syms xp yp thp phip psip real;
syms xpp ypp thpp phipp psipp real;

Is = sym('I', [3, 1], 'real');
I = diag(Is);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x; y; 0]);
T2 = T3d(th, [0; 0; 1], [0; 0; 0]);
T3 = T3d(psi, [1; 0; 0], [0; 0; 0]);
T4 = T3d(0, [0; 0; 1], [0; 0; R]);
T5 = T3d(phi, [0; -1; 0], [0; 0; 0]);
Ts = {T1, T2, T3, T4, T5};

% CG position relative to body coordinate system
L = [0; 0; 0];

% Generalized coordinates
sys.kin.q = [x; y; th; phi; psi];
sys.kin.qp = [xp; yp; thp; phip; psip];
sys.kin.qpp = [xpp; ypp; thpp; phipp; psipp];

% Previous body
previous = struct('');

wheel = build_body(m, I, Ts, L, {}, {}, ...
                   sys.kin.q, sys.kin.qp, sys.kin.qpp, ...
                   previous, []);
sys.descrip.bodies = {wheel};

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Paramater symbolics of the system
sys.descrip.syms = [m, R, Is.', g];

% Penny data
% m_num = 2.5e-3;
% R_num = 9.75e-3;
m_num = 1;
R_num = 1;
sys.descrip.model_params = [m_num, R_num, ...
                            m_num*R_num^2/2, ...
                            m_num*R_num^2/4, ...
                            m_num*R_num^2/2, ...
                            9.8];

% External excitations
sys.descrip.Fq = [0; 0; f_th; f_phi; f_psi];
sys.descrip.u = [f_th; f_phi; f_psi];

% State space representation
sys.descrip.states = [x; y; th; phi; psi];

% Constraint condition
sys.descrip.is_constrained = true;

% Nonholonomic constraints
sys.descrip.unhol_constraints = xp*sin(th) - yp*cos(th);

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

A = [1, 0, -R, 0];
sys = constrain_system(sys, A);

% Time [s]
dt = 0.1;
tf = 10 ;
t = 0:dt:tf; 

% Initial conditions [m; m/s]
% x = 1, y = 1, v = 1
x0 = [0, 0, 0, 0, pi/4, 1, 0, 0]';

% System modelling
u_func = @(t, x) zeros(length(sys.descrip.u), 1);
sol = validate_model(sys, t, x0, u_func, false);

x = sol.x.';
y = sol.y.';

% Generalized coordinates
plot_info_q.titles = {'$x$', '$y$', '$\theta$', '$\phi$', '$\psi$'};
plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', ...
                       '$t$ [s]', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$', '$\psi$'};
plot_info_q.grid_size = [2, 2];

hfigs_states = my_plot(x, y(:, 1:4), plot_info_q);

plot_info_p.titles = {'$\omega_{\theta}$', '$\omega_{\phi}$', ...
                      '$\omega_{\psi}$'};
plot_info_p.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info_p.ylabels = {'$\omega_{\theta}$', '$\omega_{\phi}$', ...
                       '$\omega_{\psi}$'};
plot_info_p.grid_size = [3, 1];

% States plot
hfigs_speeds = my_plot(x, y(:, 5:7), plot_info_p);

% Energies plot
hfig_energies = plot_energies(sys, x, y);
hfig_consts = plot_constraints(sys, x, y);

% Images
saveas(hfig_energies, '../images/energies', 'epsc');
saveas(hfigs_states(1), ['../images/states', num2str(1)], 'epsc'); 
saveas(hfigs_speeds(1), ['../images/speeds', num2str(1)], 'epsc'); 
saveas(hfig_consts(1), ['../images/consts', num2str(1)], 'epsc'); 
