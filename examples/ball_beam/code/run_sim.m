% Time [s]
dt = 0.1;
tf = 10;

u_func = @(t, x) 0;

% Initial conditions [m; m/s]
x0 = ones(size([sys.kin.q; sys.kin.p]));
curr_state0 = x0;

% Model loading
model_name = 'simple_model';
simOut = simsys(model_name, sys, x0, tf);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
x = [q, p];

t = simOut.tout;
