% Time [s]
tf = 2*pi/omega;
dt = tf/100;

[~, m] = size(sys.dyn.Z);

u_func = @(t, x) zeros(m, 1);

% Initial conditions [m; m/s]

% Model loading
model_name = 'simple_model';
simOut = simsys(model_name, sys, x0, tf);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
x = [q, p];

t = simOut.tout;
x = [q, p];
