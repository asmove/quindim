% Author: Bruno Peixoto
% Date: 08/01/19
clear all
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
syms x y theta phi real;
syms xp yp thetap phip real;
syms xpp ypp thetapp phipp real;

Is = sym('I', [3, 1], 'real');
I = diag(Is);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x; y; R]);
T2 = T3d(theta, [0; 0; 1], [0; 0; 0]);
T3 = T3d(phi, [0; -1; 0], [0; 0; 0]);
Ts = {T1, T2, T3};

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
                           {'p_1'}, ...
                           {'p_2'}};

sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', 'x', ...
                          '\ddot{y}', '\dot{y}', 'y', ...                          
                          '\ddot{\theta}', ...
                          '\dot{\theta}', ...
                          '\theta', ...
                          '\ddot{\phi}', ...
                          '\dot{\phi}', ...
                          '\phi', ...
                          '\omega_{\phi}', ...
                          '\omega_{\theta}'};

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
sys.descrip.Fq = [0; 0; f_th; f_phi];
sys.descrip.u = [f_phi; f_th];

% State space representation
sys.descrip.states = [x; y; theta; phi];

% Constraint condition
sys.descrip.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);

T12 = T1*T2;
T = T12*T3;
R12 = T12(1:3, 1:3);
R_ = T(1:3, 1:3);

v_cg = simplify_(sys.descrip.bodies{1}.v_cg);
[~, omega_] = omega(R_, sys.kin.q, sys.kin.qp);

v_contact = v_cg + cross(omega_, R12*[0; 0; -R]);
w = R12*[0; 1; 0];
constraints = simplify_(dot(v_contact, w));

sys.descrip.is_constrained = true;
sys.descrip.unhol_constraints = constraints;

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

A = [1, 0, -R];
sys = constrain_system(sys, A);

% Time [s]
dt = 0.1;
tf = 10;
t = 0:dt:tf; 

% Initial conditions
x0 = [1, 1, 0, 0, 1, 1]';

% % System modelling
% u_func = @(t, x) zeros(length(sys.descrip.u), 1);
% sol = validate_model(sys, t, x0, u_func);
% 
% x = t';
% y = sol';
% 
% % Generalized coordinates
% plot_info_q.titles = repeat_str('', 4);
% plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
% plot_info_q.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$'};
% plot_info_q.grid_size = [2, 2];
% 
% hfigs_states = my_plot(x, y(:, 1:4), plot_info_q);
% 
% plot_info_p.titles = repeat_str('', 3);
% plot_info_p.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]'};
% plot_info_p.ylabels = {'$p_1$', '$p_2$', '$p_3$'};
% plot_info_p.grid_size = [3, 1];
% 
% % States plot
% hfigs_speeds = my_plot(x, y(:, 5:end), plot_info_p);
% 
% % Energies plot
% hfig_energies = plot_energies(sys, x, y);
% hfig_consts = plot_constraints(sys, x, y);
% 
% % Images
% saveas(hfig_energies, '../images/energies', 'epsc');
% saveas(hfigs_states(1), ['../images/states', num2str(1)], 'epsc'); 
% saveas(hfigs_speeds(1), ['../images/speeds', num2str(1)], 'epsc'); 
% saveas(hfig_consts(1), ['../images/consts', num2str(1)], 'epsc'); 
