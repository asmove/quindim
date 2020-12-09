% Differential robot
% @Author: Bruno Peixoto
clear all
PLOT_DATA = false;

% Load car model
run('./load_model.m');

% Run simulation
run('./run_sim.m');

if(PLOT_DATA)
    % Run plot script
    run('./run_plot.m');
end

% Run robot animation
run('./run_animation.m');
