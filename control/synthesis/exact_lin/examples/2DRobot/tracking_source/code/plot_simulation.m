close all

clear plot_info_q;
clear plot_info_p;
clear plot_info_traj;
clear plot_info_readings;

% Generalized coordinates
plot_info_q.titles = repeat_str('', 3);
plot_info_q.xlabels = repeat_str('$t$ [s]', 3);
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$'};
plot_info_q.grid_size = [3, 1];
plot_info_q.legends = {{'$x$', '$x^{\star}$'}, ...
                          {'$y$', '$y^{\star}$'}, ...
                          {'$\theta$'}};
plot_info_q.pos_multiplots = [1, 2];
plot_info_q.markers = {{'-', '--'}, {'-', '--'}};

trajs_t = [];
for i = 1:length(trajs)
    trajs_i = trajs{i};
    trajs_t = [trajs_t; trajs_i(:, 1:2)];
end

[n_s, ~] = size(sol);
[n_t, ~] = size(trajs_t);

n_min = min(n_s, n_t);

time_y = time(1:n_min);
ys = {sol(1:n_min, 1:3), trajs_t(1:n_min, :)};

hfigs_states = my_plot(time_y, ys, plot_info_q);

% xy-coordinates
hfigs_states_xy = my_figure();
plot(sol(:, 1), sol(:, 2));
hold on;
plot(estimations(:, 1), estimations(:, 2), 'ko');
hold on;

for i = 1:length(trajs)
    trajs_i = trajs(i);
    trajs_i = [trajs_i{1}];
    plot(trajs_i(:, 1), trajs_i(:, 2), 'r--');
    hold on;
end

hold off;

xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');

axis square;
grid;

% Speeds plot
plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = repeat_str('$t$ [s]', 2);
plot_info_p.ylabels = {'$\dot x$', '$\dot y$'};
plot_info_p.grid_size = [2, 1];

time_speed = time(1:n_min);
speed = sol(1:n_min, 3:4);

hfigs_speeds = my_plot(time_speed, speed, plot_info_p);

% Control plot
plot_info_u.titles = repeat_str('', 2);
plot_info_u.xlabels = repeat_str('$t$ [s]', 2);
plot_info_u.ylabels = {'$\tau_{\theta}$', '$\tau_{\phi}$'};
plot_info_u.grid_size = [2, 1];

hfigs_u = my_plot(tu_s, u_s, plot_info_u);

% Trajectory plot
plot_info_traj.titles = repeat_str('', 2);
plot_info_traj.xlabels = repeat_str('$t$ [s]', 2);
plot_info_traj.ylabels = {'$x^{\star}$', '$y^{\star}$'};
plot_info_traj.legends = {{'$x^{\star}$', '$x$'}, ...
                          {'$y^{\star}$', '$y$'}};
plot_info_traj.grid_size = [2, 1];
plot_info_traj.pos_multiplots = [1, 2];
plot_info_traj.markers = {{'-', '--'}, {'-', '--'}};

ts_ = [];
trajs_ = [];
for i = 1:length(trajs)
    trajs_i = trajs{i};
    t_trajs_i = t_trajs{i};
    
    ts_ = [ts_; t_trajs_i];
    trajs_ = [trajs_; trajs_i];
end

len_ts = length(ts_);
[len_trajs, ~] = size(trajs_);
[len_sol, ~] = size(sol);

len_min = min([len_ts, len_trajs, len_sol]);

ts_traj = ts_(1:len_min);
traj_ = {trajs_(1:len_min, :), ...
    sol(1:len_min, 1:2)};

hfigs_referemce = my_plot(ts_traj, traj_, plot_info_traj);

% Readings
plot_info_readings.titles = {''};
plot_info_readings.xlabels = {'$t$ [s]'};
plot_info_readings.ylabels = {'Sinal de campo [ ]'};
plot_info_readings.grid_size = [1, 1];

% Readings plot
hfigs_readings = my_plot(t_readings, readings, plot_info_readings);

saveas(hfigs_states, ['../imgs/states_', traj_type, '.eps'], 'epsc');
saveas(hfigs_states_xy, ['../imgs/states_xy_', traj_type, '.eps'], 'epsc');
saveas(hfigs_speeds, ['../imgs/speeds_', traj_type, '.eps'], 'epsc');
saveas(hfigs_u, ['../imgs/control_', traj_type, '.eps'], 'epsc');
saveas(hfigs_readings, ['../imgs/readings', traj_type, '.eps'], 'epsc');
