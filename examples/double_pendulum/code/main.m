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

titles = {'$x$', '$\theta_1$', '$\theta_2$', ...
          '$\dot x$', '$\dot \theta_1$', '$\dot \theta_2$'};
xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
ylabels = {'$x$ $[m]$', '$\theta_1$ $[rad]$', '$\theta_2$ $[rad]$', ...
           '$\dot x$ $[m/s]$', '$\dot \theta_1$ $[rad/s]$', ...
           '$\dot \theta_2$  $[rad/s]$'};

% States and energies plot
hfigs_states = plot_states(x, y, titles, xlabels, ylabels);
hfig_energies = plot_energies(sys, x, y);

% Energies
saveas(hfig_energies, '../images/energies', 'epsc');

for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../images/states', num2str(i)], 'epsc'); 
end
