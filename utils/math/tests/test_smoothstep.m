clear all
close all
clc

T = 10;
t_mid = 5;
y_begin = 1;
y_end = 0;
dt = 0.01;

time = 0:dt:T;

degrees = [0, 1, 2, 3, 4, 5];

degrees_str = {};
for degree = degrees
    degrees_str{end+1} = ['Degree $', num2str(degree), '$'];
end

ys = zeros(length(time), 6);
for degree = degrees
    for i = 1:length(time)
        ys(i, degree+1) = smoothstep(time(i), t_mid, y_begin, y_end, degree);
    end
end

plot_info.titles = degrees_str;
plot_info.xlabels = repeat_str('$t$ [s]', 6);
plot_info.ylabels = repeat_str('$y(t)$', 6);
plot_info.grid_size = [3, 2];

time = time';

hfigs_phat = my_plot(time, ys, plot_info);