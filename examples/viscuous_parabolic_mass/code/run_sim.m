% Initia conditions [m; m/s]
x0 = [1; 1; 0];

% Final time
tf = 1;
dt = 0.001;
tspan = 0:dt:tf;

u_func = @(t, x) 0;

% System modelling
model_name = 'simple_model';

abs_tol = '1e-6';
rel_tol = '1e-6';

simcode_gen = @(sys, model_name) gen_scripts(sys, model_name);
simOut = sim_block_diagram(sys, model_name, ...
                           simcode_gen, abs_tol, rel_tol);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
x = [q, p];

states = simOut.states.signals.values;
q_speeds = simOut.q_speeds.signals.values;
tspan = simOut.tout;
