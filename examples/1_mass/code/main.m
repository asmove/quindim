
% Author: Senzu
% Date: 08/01/19

if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

% Body 1
syms m b k g real;
syms x xp xpp real;
syms F;

I = sym(zeros(3, 3));

Ts = {T3d(0, [0; 0; 1], [x; 0; 0])};
is_friction_linear1 = true;

% Previous body - Inertial, in this case
% CG position relative to body coordinate system
L = [0; 0; 0];

% Bodies inertia
damper = build_damper(b, [0; 0; 0], [xp; 0; 0]);
spring = build_spring(k, [0; 0; 0], [x; 0; 0]);

previous = struct('');
body = build_body(m, I, Ts, L, {damper}, {spring}, ...
                  x, xp, xpp, previous, []);

sys.descrip.syms = [m, b, k, g];

% Paramater symbolics of the system
sys.descrip.model_params = [1, 1, 9, 9.8];

sys.descrip.bodies = {body};

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Generalized coordinates
sys.kin.q = [x];
sys.kin.qp = [xp];
sys.kin.qpp = [xpp];

% Quasi-velocities
sys.kin.p = [xp];
sys.kin.pp = [xpp];

% External excitations
sys.descrip.Fq = F;
sys.descrip.u = F;

% Sensors
sys.descrip.y = [x];

% State space representation
sys.dyn.states = [x; xp];

% Constraint condition
sys.descrip.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Decay time
m_num = sys.descrip.model_params(1);
b_num = sys.descrip.model_params(2);
T = m_num/b_num;

% Initia conditions [m; m/s]
x0 = [0; 1];

m_num = sys.descrip.model_params(1);
k_num = sys.descrip.model_params(3);
omega = sqrt(k_num/m_num);

% Time [s]
tf = 2*pi/omega;
dt = tf/100;
t = 0:dt:tf;

[~, m] = size(sys.dyn.Z);

u_func = @(t, x) zeros(m, 1);

% Initial conditions [m; m/s]

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

plot_info.titles = {'$x$', '$\dot x$'};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$x$ $[m]$', '$\dot x$ $[m/s]$'};
plot_info.grid_size = [2, 1];

% States and energies plot
hfigs_states = my_plot(t, x, plot_info);
hfig_energies = plot_energies(sys, t, x);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');

for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../imgs/states', num2str(i)], 'epsc'); 
end
