close all

% Generalized coordinates
plot_info_q.titles = repeat_str('', 2);
plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$'};
plot_info_q.grid_size = [2, 1];

% States plot
hfigs_states = my_plot(time, sol(:, 1:2), plot_info_q);

% xy-coordinates
hfigs_states_xy = my_figure();
plot(sol(:, 1), sol(:, 2));
hold on;
plot(estimations(:, 1), estimations(:, 2), 'ko');
hold on;

for i = 1:length(trajs)
    trajs_i = trajs(i);
    plot(trajs_i(:, 1), trajs_i(:, 2), 'r--');
    hold on;
end

[n, ~] = size(estimations);

x = xs_curr(1:n, 1);
y = xs_curr(1:n, 2);

u = zeros(n, 1);
v = zeros(n, 1);
for i = 1:n
    delta_x = estimations(i, 1) - xs_curr(i, 1);
    delta_y = estimations(i, 2) - xs_curr(i, 2);
    
    norm_vec = sqrt(delta_x^2 + delta_y^2);
    
    u(i) = delta_x/norm_vec;
    v(i) = delta_y/norm_vec;
end

quiver(x, y, u, v, '-');

hold off;

xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');

axis square;

plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = repeat_str('$t$ [s]', 2);
plot_info_p.ylabels = {'$\dot x$', '$\dot y$'};
plot_info_p.grid_size = [2, 1];

% Speeds plot
hfigs_speeds = my_plot(time, sol(:, 3:4), plot_info_p);

plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = repeat_str('$t$ [s]', 2);
plot_info_p.ylabels = {'$\tau_{\theta}$', '$\tau_{\phi}$'};
plot_info_p.grid_size = [2, 1];

% Trajectory plot
plot_info_traj.titles = repeat_str('', 2);
plot_info_traj.xlabels = repeat_str('$t$ [s]', 2);
plot_info_traj.ylabels = {'$x^{\star}$', '$y^{\star}$'};
plot_info_traj.grid_size = [2, 1];

trajs = double(trajs);
hfigs_speeds = my_plot(t_trajs, double(trajs), plot_info_traj);

% Control plot
hfigs_u = my_plot(tu_s, u_s, plot_info_p);

plot_info_p.titles = {''};
plot_info_p.xlabels = {'$t$ [s]'};
plot_info_p.ylabels = {'Sinal de campo [ ]'};
plot_info_p.grid_size = [1, 1];

% Readings plot
hfigs_readings = my_plot(t_readings, readings, plot_info_p);

saveas(hfigs_states, '../imgs/states.eps', 'epsc');
saveas(hfigs_states_xy, '../imgs/states_xy.eps', 'epsc');
saveas(hfigs_speeds, '../imgs/speeds.eps', 'epsc');
saveas(hfigs_u, '../imgs/control.eps', 'epsc');
saveas(hfigs_readings, '../imgs/readings.eps', 'epsc');
