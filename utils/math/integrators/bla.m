% This code is made by Ahmed Eltahan
% This code intends to solve 1st order ODE Runge訪utta芳ehlberg procedure which is 6th order accuracy 
clc; 
close all; 
clear all;

% Inputs and Declaration
dt = 0.01; % solution stepsize
tspan = 0:dt:pi/4;  % input vector

% Function declaration
f = @(x, y) (y-x-1)^2+2;

% Initial conditions
x0 = 1;

% vector related to RKF procdure
gamma = [16/135; ...
         0; ...
         6656/12825; ...
         28561/56430; ...
         -9/50; ...
         2/55];

sol = x0;
x_1 = x0;

y_RKF(1) = 1;

% Core: Runge Kutta 6th order procedure
for i = 2:length(tspan)
%     t = tspan(i);
%     k1 = func(t, x_1);
%     k2 = func(t + dt/4, ...
%               x_1 + k1/4);
%     k3 = func(t + 3/8*dt, ...
%               x_1 + 3/32*k1 + 9/32*k2);
%     k4 = func(t + 12/13*dt, ...
%               x_1 + 1932/2197*k1 - 7200/2197*k2 + 7296/2197*k3);
%     k5 = func(t + dt, ...
%               x_1 + 439/216*k1 - 8*k2 + ...
%               3680/513*k3 - 845/4104*k4);
%     k6 = func(t + dt/2, ...
%               x_1 - 8/27*k1 + 2*k2 - 3544/2565*k3 + ...
%                     1859/4104*k4 - 11/40*k5);
% 
%     K = double([k1, k2, k3, k4, k5, k6]);
% 
%     % new solution
%     x = x_1 + dt*K*gamma;
%     sol(:, end+1) = x;
%     
%     x_1 = x;
    t = tspan(i);
    
    k1 = dt*f(t, x_1);
    k2 = dt*f(t+dt/4, x_1+k1/4);
    k3 = dt*f(t+3/8*dt, x_1+3/32*k1+9/32*k2);
    k4 = dt*f(t+12/13*dt, x_1+1932/2197*k1-7200/2197*k2+7296/2197*k3);
    k5 = dt*f(t+dt, x_1+439/216*k1-8*k2+3680/513*k3-845/4104*k4);
    k6 = dt*f(t+dt/2, x_1-8/27*k1+2*k2-3544/2565*k3+1859/4104*k4-11/40*k5);
    K = [k1, k2, k3, k4, k5, k6];
    x = x_1+ K*gamma;

    x_1 = x;
    sol(:, end+1) = x;
end

% Analytical Exact Solution
y_exact = tan(tspan) + tspan + 1;
error_RKF = y_exact - y_RKF;

% Plot and Comparison
w = figure(1);
plot(tspan, y_exact, tspan, sol, 'LineWidth', 2);
grid on
xlabel('x')
ylabel('y')
title('Plot of the Exact and Numerical RKF Solutions')
legend('RKF solution', 'Exact solution')
print(w, '-dpng', '-r720', 'Exact_VS_RKF')

w = figure(2);
plot(tspan, error_RKF, 'LineWidth', 2);
grid on
xlabel('x')
ylabel('Error RKF')
title('Plot of the Error between Exact and Numerical RKF Solutions')
print(w, '-dpng', '-r720', 'Error_RKF')