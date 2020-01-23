clear all
close all
clc

y_begin = 1;
y_end = 2;
T = 1;

tspan = 0:0.01:T;

degrees = 1:5;

smoothsteps = [];
for degree = degrees
    ys = zeros(length(tspan), 1);
    for i = 1:length(tspan)
        ti = tspan(i);
        ys(i) = smoothstep(ti, T, y_begin, y_end, degree);
    end
    smoothsteps = [smoothsteps, ys];
end


plot_config.titles = {'Smoothstep $S_n(t)$'};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$S_n(t)$'};
plot_config.grid_size = [1, 1];
plot_config.legends = strsplit(num2str(degrees));
plot_config.pos_multiplots = ones(1, length(degrees)-1);
plot_config.markers = {'b', 'm', 'k', 'c', 'r'};

ys = {smoothsteps(:, 1), ...
      smoothsteps(:, 2:end)};

hfig_lyapunov = my_plot(tspan', ys, plot_config);

smoothsteps_path = '../imgs/smoothsteps.eps';
saveas(hfig_lyapunov, smoothsteps_path, 'epsc');