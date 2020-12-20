% Calculate value for q_circ
[mechanism.q_circ_fun, ...
 mechanism.is_ws_fun] = load_q_circ(mechanism);

% Simulation
traj = trajectory();
sims = calculate_sims(mechanism, traj, false);