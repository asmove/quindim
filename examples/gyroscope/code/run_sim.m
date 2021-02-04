% Initia conditions [m; m/s]
x0 = [pi/4; pi/4; pi/4; pi/4; ...
      1; 1; 1; 1];

% Time [s]
dt = 0.05;
tf = 5;

% System modelling
[~, m] = size(sys.dyn.Z);

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
