clear all
close all
clc

T = 0.5;
P0 = [0; 0];
P1 = [1; 1];
alphaA = 0.3;
alphaB = 0.3;
n_diff = 0;

traj_func = @(t) bezier_path2(t, T, P0, P1, 0, ...
                             alphaA, alphaB, n_diff);

dt = 0.01;
tf = T;
t = (0:dt:tf)';

way = [];
for i = 1:length(t)
   way = [way; traj_func(t(i))'];
end

plot_info_traj.titles = {''};
plot_info_traj.xlabels = {'$x^{\star}$'};
plot_info_traj.ylabels = {'$y^{\star}$'};
plot_info_traj.grid_size = [1, 1];

hfigs_speeds = my_plot(way(:, 1), way(:, 2), plot_info_traj);