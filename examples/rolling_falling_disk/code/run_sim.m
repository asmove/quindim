% Time [s]
dt = 0.05;
tf = 10 ;

% Initial conditions [m; m/s]
% x = 1, y = 1, v = 1
x0 = [0, 0, 0, 0, pi/4, 1, 0, 0]';

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