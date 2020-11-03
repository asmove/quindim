% Minimal example
% @Author: Bruno Peixoto
if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

% The 'real' statement on end is important
% for inner simplifications
syms Ra Rs La k_b k_m ks Tpl Tf Beq Jeq sigma g L real;
syms x xp xpp u real;

% Paramater symbolics of the system
sys.descrip.syms = [Ra Rs La k_b k_m ks Tpl Tf Beq Jeq sigma];

% Paramater symbolics of the system
sys.descrip.model_params = [1.15, 1.5, 0.0015, 0.383, 0.383, ...
                            0.087, 0.396, 0.284, 0.0088, 0.0021 19];

model_params = sys.descrip.model_params;

% Gravity utilities
sys.descrip.gravity = [0; 0; 0];
sys.descrip.g = g;

% Body inertia
Inertia = diag(sym([Jeq, Jeq, Jeq]));

% Position relative to body coordinate system
Lg = zeros(3, 1);

% Bodies definition
T = {T3d(x, [0; 0; 1], [0; 0; 0])};

damper = build_damper(Beq, [0; 0; 0], [1; 0; 0]);
spring = build_spring(ks, [0; 0; 0], [1; 0; 0]);
block = build_body(0, Inertia, T, [0; 0; 0], {damper}, {spring}, ...
                   x, xp, xpp, struct(''), []);

sys.descrip.bodies = {block};

% Generalized coordinates
sys.kin.q = x;
sys.kin.qp = xp;
sys.kin.qpp = xpp;

% External excitations
s_f = 2/(1+exp(-sigma*xp)) - 1;
sys.descrip.Fq = (k_m/Ra)*(-k_b*xp + u) + Tf*s_f - Tpl;
sys.descrip.u = u;

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = x;

% State space representation
sys.descrip.states = [x; xp];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

scaler = 100;
tf = 10;
dt = tf/scaler;
t = 0:dt:tf;

% Initia conditions [m; m/s]
x0 = [0; 1];

% System modelling
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
tspan = simOut.tout;

titles = {'', ''};
xlabels = {'$t$ [s]', '$t$ [s]'};
ylabels = {'$\theta$ [rad]', '$\dot{\theta}$ [rad/s]'};
grid_size = [2, 1];

% Plot properties
plot_info.titles = titles;
plot_info.xlabels = xlabels;
plot_info.ylabels = ylabels;
plot_info.grid_size = grid_size;

[hfigs_states, hfig_energies] = plot_sysprops(sys, t, x, plot_info);

% Energies
saveas(hfig_energies, '../imgs/energies.eps', 'epsc');

% States
for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../imgs/states', num2str(i), '.eps'], 'epsc'); 
end

