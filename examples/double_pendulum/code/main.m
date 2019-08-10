% Double Double example
% @Author: Bruno Peixoto

% Plant parameters
sys = double_pendulum();

% Initia conditions [m; m/s]
x0 = [0; 0; pi/3; 0; pi/6; 0];

% Time [s]
dt = 0.001;
tf = 2;
t = 0:dt:tf; 

% System modelling
sol = validate_model(sys, t, x0, 0);
x = sol.x;
y = sol.y.';

% Little rearrangement for plot purposes
y = [y(:, 1), y(:, 4),...
     y(:, 2), y(:, 5), ...
     y(:, 3), y(:, 6)];

plot_config.titles = {'$x$', '$\dot x$', '$\theta_1$', ...
           '$\dot \theta_1$', '$\theta_2$', '$\dot \theta_2$'};
plot_config.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_config.ylabels = {'$x$ $[m]$', '$\dot x$ $[m/s]$', ...
                     '$\theta_1$ $[rad]$', '$\dot \theta_1$ $[rad/s]$', ...
                     '$\theta_2$ $[rad]$', '$\dot \theta_2$  $[rad/s]$'};
plot_config.grid_size = [3, 2];
       
% States and energies plot
hfigs_states = my_plot(x, y, plot_config);
hfig_energies = plot_energies(sys, x, y);

% Energies
saveas(hfig_energies, '../images/energies', 'epsc');

for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../images/states', num2str(i)], 'epsc'); 
end
