% Initia conditions [m; m/s]
x0 = [];

for i = 1:n_mbk
    x0 = [x0; 1; 0];
end

[~, m] = size(sys.dyn.Z);

u_func = @(t, x) zeros(m, 1);

% Initial conditions [m; m/s]

% Model loading
model_name = 'simple_model';
simOut = simsys(model_name, sys, x0, tf);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
t = simOut.tout;

x = [q, p];