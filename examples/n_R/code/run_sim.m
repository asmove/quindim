% Initia conditions [m; m/s]
x0 = [];

for i = 1:n_R
    x0 = [x0; 0; 0];
end

tf = 10;

% Initial conditions [m; m/s]

% Model loading
model_name = 'simple_model';
simOut = simsys(model_name, sys, x0, tf);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
tspan = simOut.tout;

x = [q, p];
