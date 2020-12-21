
% Initial conditions [m; m/s]
x0 = [0; pi/3; 0; 0];

% Time [s]
tf = 2;
dt = 0.01;

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