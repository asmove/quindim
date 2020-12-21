% Time [s]
dt = 0.1;
tf = 5;

% Initial conditions
x0 = [0, 0, 1, 1]';

% System modelling
u_func = @(t, x) zeros(length(sys.descrip.u), 1);

% Model loading
model_name = 'simple_model';
simOut = simsys(model_name, sys, x0, tf);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
x = [q, p];

t = simOut.tout;
