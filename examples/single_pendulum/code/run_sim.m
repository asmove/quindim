% Initia conditions [m; m/s]
x0 = [pi/3; 0];

L_num = sys.descrip.model_params(end);
g_num = sys.descrip.model_params(end-1);

% Time [s]
dt = 0.01;
tf = 2*pi*sqrt(L_num/g_num)*1.5;

% System modelling
u_func = @(t, x) zeros(length(sys.descrip.u), 1);

% Model loading
model_name = 'simple_model';
simOut = simsys(model_name, sys, x0, tf);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
x = [q, p];

states = simOut.states.signals.values;
q_speeds = simOut.q_speeds.signals.values;
t = simOut.tout;
