% This code is made by Ahmed Eltahan
% This code intends to solve 1st order ODE Runge-Kutta-Fehlberg 
% procedure which is 6th order accuracy 
clc; 
close all; 
clear all;

% Inputs and Declaration
% solution stepsize and final time
dt = 0.01;
tf = 0.2;

degrees = [1, 2, 3, 4, 5, 6, 7, 8];
% degrees = 2;

% Function declaration
func = @(x, y) -y;

% Initial conditions
x0 = 1;

% input vector
tspan = 0:dt:tf;
tspan = tspan';

% Analytical Exact Solution
y_exact = x0*exp(-tspan);

errors = zeros(length(tspan)-1, length(degrees));
sols = zeros(length(tspan), length(degrees));
for i = 1:length(degrees)
    degree = degrees(i);
    
    [t, sol] = ode(degree, func, x0, dt, 0, tf);
    sol = sol';

    % Errors
    errors(:, i) = log10(abs(y_exact(2:end) - sol(2:end)));

    % Solutions
    sols(:, i) = sol;
end

errors = {errors(:, 1), errors(:, 2:end)};

% Plot and Comparison
plot_config.titles = {'Nummeric integration methods'};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$y(t)$'};
plot_config.grid_size = [1, 1];
plot_config.legends = {'Exact', '1', '2', '3', '4', '5', '6', '7', '8'};
plot_config.pos_multiplots = ones(1, length(plot_config.legends)-1);
plot_config.markers = {'-', '--', '.-', 's-', '*-', '-o', 'd-', 'p-', '+-'};

ys = {y_exact, sols};
my_plot(tspan, ys, plot_config);

plot_config.titles = {'Relative error'};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$\log_{10}(|e(t)|)$'};
plot_config.grid_size = [1, 1];
plot_config.legends = {'1', '2', '3', '4', '5', '6', '7', '8'};
plot_config.pos_multiplots = ones(1, length(plot_config.legends)-1);
plot_config.markers = {'--', '.-', 's-', '*-', 'o-', 'd-', 'p-', '+-'};

my_plot(tspan(2:end), errors, plot_config);




