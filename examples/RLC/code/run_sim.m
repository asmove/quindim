% Decay time
L_num = sys.descrip.model_params(1);
R_num = sys.descrip.model_params(2);
C_num = 1/sys.descrip.model_params(3);

% Time [s]
% omega = 1/sqrt(L_num*C_num);
% tf = 2*pi/omega;
R = model_params(2);
L = model_params(1);
C = 1/model_params(3);

alpha = R/(2*L);
w_d = sqrt(1/(L*C) - R^2/(4*L^2));
xi = w_d/alpha;
zeta = sqrt(1/(1 + xi^2));
w_n = alpha/zeta;

tf = 2*pi/w_n;

scaler = 100;
dt = tf/scaler;

% Initia conditions [m; m/s]
x0 = [0; 1];

u_func = @(t, x) 0;

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
