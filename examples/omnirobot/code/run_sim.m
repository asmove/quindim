% Initial conditions [m; m/s]

% Linear velocity in x, y and/or theta
x0 = [0; 0; 0; 0; 0; 0; 0; 0; 1];
u0 = [0; 0; 0];

% Time [s]
tf = 5;

% System modelling
model_name = 'simple_model';

script_generator = @(sys, model_name) ...
                   gen_scripts(sys, model_name);

abs_tol = '1e-6';
rel_tol = '1e-6';

simOut = sim_block_diagram(sys, model_name, ...
                           script_generator, ...
                           abs_tol, rel_tol);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
x = [q, p];

states = simOut.states.signals.values;
q_speeds = simOut.q_speeds.signals.values;
tspan = simOut.tout;

