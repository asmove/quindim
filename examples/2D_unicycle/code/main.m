% Author: Bruno Peixoto
% Date: 08/01/19

if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

syms g tau_r tau_l;

% Body 1
syms m R L real;
syms x_pos y_pos theta threal;
syms xp yp thetap real;
syms xpp ypp thetapp real;

I = inertia_tensor('1', true);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x_pos; y_pos; 0]);
T2 = T3d(theta, [0; 0; 1], [0; 0; 0]);
Ts = {T1, T2};

% CG position relative to body coordinate system
Lg = [0; 0; 0];

% Generalized coordinates
sys.kin.q = [x_pos; y_pos; theta];
sys.kin.qp = [xp; yp; thetap];
sys.kin.qpp = [xpp; ypp; thetapp];

sys.descrip.latex_origs = {{'xpp'}, ...
                           {'\mathrm{xp}'}, ...
                           {'x_pos'}, ...
                           {'ypp'}, ...
                           {'\mathrm{yp}'}, ...
                           {'y_pos'}, ...
                           {'thetapp'}, ...
                           {'thetap'}, ...
                           {'\mathrm{theta}'}};
sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', 'x', ...
                          '\ddot{y}', '\dot{y}', 'y', ...                          
                          '\ddot{\theta}', ...
                          '\dot{\theta}', ...
                          '\theta'};

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
% https://www.neobotix-roboter.de/produkte/mobile-roboter/mobiler-roboter-mp-500
m_num = 1;
R_num = 33e-3;
L_num = 138e-3;
W_num = 178e-3;
d_cg = 33e-3;

sys.descrip.model_params = [m_num, R_num, ...
                            0, 0, m_num*(L_num^2 + W_num^2)/3 + ...
                            m_num*d_cg^2, 9.8, L_num];

% External excitations
R = sys.descrip.syms(2);
L = sys.descrip.syms(end);
U = [cos(theta)/R, cos(theta)/R; sin(theta)/R, sin(theta)/R; L/R, -L/R];
sys.descrip.u = [tau_r; tau_l];
sys.descrip.Fq = U*sys.descrip.u;

% State space representation
sys.descrip.states = [x_pos; y_pos; theta];

% Constraint condition
sys.descrip.is_constrained = true;
sys.descrip.unhol_constraints = xp*sin(theta) - yp*cos(theta);

% Kinematic and dynamic model
sys = kinematic_model(sys);

sys.kin.C(:, 1) = sin(theta)*sys.kin.C(:, 1);
sys.kin.Cs{1} = sys.kin.C;

sys = dynamic_model(sys);

% Time [s]
dt = 0.01;
tf = 1;
t = 0:dt:tf; 

% Initial conditions
x0 = [0, 0, 0, 1, 1]';

% System modelling
u_func = @(t, x) zeros(length(sys.descrip.u), 1);

% Initial conditions [m; m/s]
curr_state0 = x0;

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

t = simOut.tout;

% Generalized coordinates
plot_info_q.titles = repeat_str('', 3);
plot_info_q.xlabels = {'', '', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$'};
plot_info_q.grid_size = [3, 1];

hfigs_states = my_plot(t, x(:, 1:3), plot_info_q);

plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = {'', '$t$ [s]'};
plot_info_p.ylabels = {'$v$', '$\omega$'};
plot_info_p.grid_size = [2, 1];

% States plot
hfigs_speeds = my_plot(t, x(:, 4:5), plot_info_p);

% Energies plot
hfig_energies = plot_energies(sys, t, x);
hfig_consts = plot_constraints(sys, t, x);

% Images
saveas(hfig_energies, '../imgs/energies', 'epsc');
saveas(hfigs_states(1), ['../imgs/states', num2str(1)], 'epsc'); 
saveas(hfigs_speeds(1), ['../imgs/speeds', num2str(1)], 'epsc'); 
saveas(hfig_consts(1), ['../imgs/consts', num2str(1)], 'epsc'); 
