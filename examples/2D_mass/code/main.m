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

syms g F_x F_y;

% Body 1
syms m R L real;
syms x_pos y_pos threal;
syms xp yp real;
syms xpp ypp real;

I = inertia_tensor('1', true);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x_pos; y_pos; 0]);
Ts = {T1};

% CG position relative to body coordinate system
Lg = [0; 0; 0];

% Generalized coordinates
sys.kin.q = [x_pos; y_pos];
sys.kin.qp = [xp; yp];
sys.kin.qpp = [xpp; ypp];

sys.descrip.latex_origs = {{'xpp'}, ...
                           {'\mathrm{xp}'}, ...
                           {'x_pos'}, ...
                           {'ypp'}, ...
                           {'\mathrm{yp}'}, ...
                           {'y_pos'}};
sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', 'x', ...
                          '\ddot{y}', '\dot{y}', 'y'};

% Previous body
previous = struct('');

robot = build_body(m, I, Ts, Lg, {}, {}, ...
                   sys.kin.q, sys.kin.qp, sys.kin.qpp, ...
                   previous, []);
sys.descrip.bodies = {robot};

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Paramater symbolics of the system
sys.descrip.syms = [m, R, diag(I).', g, L];

% Penny data
% m_num = 2.5e-3;
% R_num = 9.75e-3;
m_num = 1;
R_num = 1;
L_num = 0.2;
sys.descrip.model_params = [m_num, R_num, ...
                            m_num*R_num^2/2, ...
                            m_num*R_num^2/4, ...
                            m_num*R_num^2/2, ...
                            9.8, ...
                            L_num];

% External excitations
R = sys.descrip.syms(2);
L = sys.descrip.syms(end);
sys.descrip.u = [F_x; F_y];
sys.descrip.Fq = [F_x; F_y];

% State space representation
sys.descrip.states = [x_pos; y_pos];

% Constraint condition
sys.descrip.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Time [s]
dt = 0.1;
tf = 5;
t = 0:dt:tf; 

% Initial conditions
x0 = [0, 0, 1, 1]';

% System modelling
u_func = @(t, x) zeros(length(sys.descrip.u), 1);
sol = validate_model(sys, t, x0, u_func, false);

x = t';
y = sol';

% Generalized coordinates
plot_info_q.titles = repeat_str('', 2);
plot_info_q.xlabels = {'', '', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$'};
plot_info_q.grid_size = [2, 1];

hfigs_states = my_plot(x, y(:, 1:2), plot_info_q);

plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = {'', '$t$ [s]'};
plot_info_p.ylabels = {'$x$', '$y$'};
plot_info_p.grid_size = [2, 1];

% States plot
hfigs_speeds = my_plot(x, y(:, 3:4), plot_info_p);

% Energies plot
hfig_energies = plot_energies(sys, x, y);

% Images
saveas(hfig_energies, '../imgs/energies', 'epsc');
saveas(hfigs_states(1), ['../imgs/states', num2str(1)], 'epsc'); 
saveas(hfigs_speeds(1), ['../imgs/speeds', num2str(1)], 'epsc'); 

