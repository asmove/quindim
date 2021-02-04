% Time [s]
dt = 0.01;
tf = 5;

% Initial conditions [m; m/s]
x0 = [1, 1, pi/4, 0, 0, 0, 0.5, 1, 0.5, 1]';

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
tspan = simOut.tout;
