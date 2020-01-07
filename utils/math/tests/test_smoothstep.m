clear all
close all
clc

T = 10;
t_mid = 5;
y_begin = 1;
y_end = 0;
dt = 0.01;

time = 0:dt:T;

degrees = {0, 1, 2, 3};

degrees_str = {};
for i = 1:length(degrees)
    degrees_str{end+1} = ['Degree $', num2str(degrees{i}), '$'];
end

ys = zeros(length(time), length(degrees));

for j = 1:length(degrees)
    for i = 1:length(time)
        ys(i, j) = smoothstep(time(i), t_mid, y_begin, y_end, degrees{j});
    end
end

factors = factor(length(degrees));

if(factors(1) == length(degrees))
    grid_size = [3, 1];
else
    grid_size = [factors(1), factors(2)];
end

plot_info.titles = degrees_str;
plot_info.xlabels = repeat_str('$t$ [s]', length(degrees));
plot_info.ylabels = repeat_str('$y(t)$', length(degrees));
plot_info.grid_size = grid_size;

time = time';

hfigs_phat = my_plot(time, ys, plot_info);