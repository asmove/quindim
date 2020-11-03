% Minimal example
% @Author: Bruno Peixoto

if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

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
sys.descrip.syms = [m, diag(I).', g, L];

m_num = 1;
L_num = 0.2;
sys.descrip.model_params = [m_num, m_num*L_num^2/2, ...
                            m_num*L_num^2/4, ...
                            m_num*L_num^2/2, ...
                            9.8, ...
                            L_num];

% External excitations
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

% Decay time
m_num = sys.descrip.model_params(1);
b_num = sys.descrip.model_params(2);
k_num = sys.descrip.model_params(3);
T = m_num/b_num;

% Final time
tf = 5;
dt = 0.01;
tspan = 0:dt:tf;

% Initial conditions
x0 = [0, 0, 1, 1, 0, 0, 0, 0]';

% System modelling
u_eval = @(t, x) u_brownian_2D(t, x, 1, 1, sys);
sol = validate_model(sys, tspan, x0, u_eval, true);

x = tspan';
y = sol(1:4, :)';

% Generalized coordinates
plot_info_q.titles = repeat_str('', 2);
plot_info_q.xlabels = {'', '', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$'};
plot_info_q.grid_size = [2, 1];

hfigs_states = my_plot(x, y(:, 1:2), plot_info_q);

plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = {'', '$t$ [s]'};
plot_info_p.ylabels = {'$\dot{x}$', '$\dot{y}$'};
plot_info_p.grid_size = [2, 1];

% States plot
hfigs_speeds = my_plot(x, y(:, 3:4), plot_info_p);

% Generalized coordinates
plot_info_xy.titles = repeat_str('', 1);
plot_info_xy.xlabels = {'$x$'};
plot_info_xy.ylabels = {'$y$'};
plot_info_xy.grid_size = [1, 1];

hfigs_xy = my_plot(y(:, 1), y(:, 2), plot_info_q);

% Energies plot
hfig_energies = plot_energies(sys, x, y);

% Images
saveas(hfig_energies, '../imgs/energies', 'epsc');
saveas(hfigs_states(1), ['../imgs/states', num2str(1)], 'epsc'); 
saveas(hfigs_speeds(1), ['../imgs/speeds', num2str(1)], 'epsc'); 

