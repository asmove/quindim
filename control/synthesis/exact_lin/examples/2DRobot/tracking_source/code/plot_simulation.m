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

ts = [];
trajs_t = [];
for i = 1:length(t_trajs)
    t_trajs_i = t_trajs{i};
    trajs_i = trajs{i};
    ts = [ts; t_trajs_i];
    trajs_t = [trajs_t; trajs_i];
end

[n_s, ~] = size(sol);
[n_t, ~] = size(trajs_t);

n_min = min(n_s, n_t);

time_y = time(1:n_min);
ys = {sol(1:n_min, 1:3), trajs_t(1:n_min, :)};

hfigs_states = my_plot(time_y, ys, plot_info_q);


% my_figure();
% 
% subplot(2, 1, 1);
% plot(t_trajs, trajs_t(:, 1), 'r--');
% hold on;
% plot(time, sol(:, 1), 'b-');
% hold off;
% 
% subplot(2, 1, 2);
% plot(t_trajs{1}, trajs_t(:, 2), 'r--');
% hold on;
% plot(time, sol(:, 2), 'b-');
% hold off;

% Errors
plot_info_st.titles = repeat_str('', 2);
plot_info_st.xlabels = repeat_str('$t$ [s]', 2);
plot_info_st.ylabels = {'$e_x(t)$', '$e_y(t)$'};
plot_info_st.grid_size = [2, 1];
% plot_info_st.legends = {{'$e_x^s(t)$', '$e_x^t(t)$'}, ...
%                         {'$e_y^s(t)$', '$e_y^t(t)$'}};
% plot_info_st.pos_multiplots = [1, 2];
% plot_info_st.markers = {{'-', '--'}, {'-', '--'}};
 
% errors_sim = [];
% for i = 1:n_min
%     errors_i = sol(i, 1:2) - trajs_i(i, 1:2);
%     errors_sim = [errors_sim; errors_i];
% end

% gentraj_fun = trajectory_info.gentraj_fun;
% traj_ref = gentraj_fun(0, trajs_t(1, :), ...
%                        trajs_t(end, :), sol(1, 3));
% 
% [~, ~, misc] = calc_control_2DRobot(sys, poles_);
% e0 = double(subs([misc.e; misc.ep; misc.epp], ...
%                   misc.symvars, [sol(1, :)'; traj_ref]));
% 
% e0 = [e0(1); e0(3); e0(5); e0(2); e0(4); e0(6)];
% 
% A1 = ctrb_canon(poles_{1});
% A2 = ctrb_canon(poles_{2});
% A = blkdiag(A1, A2);
% 
% e_n = canon_Rn(length(poles_{1}), 1)';
% C = blkdiag(e_n, e_n);
% 
% syms t_;
% 
% errors_t = [];
% 
% for i = 1:n_min
%     eAt = expm(A*t_);
%     CAte0 = subs(C*eAt*e0, t_, time_st(i));
%     errors_t = [errors_t; CAte0'];
% end
% 
% errors_ = {errors_sim, errors_t};
% 
% hfigs_errors = my_plot(time_st, errors_sim, plot_info_st);

% xy-coordinates
oracle = sestimation_info.oracle;

[n_s, ~] = size(sol);
[n_t, ~] = size(trajs_t);
n_min = min(n_s, n_t);
time_st = time(1:n_min);

ds = 0.001;
xmin_ = -2;
xmax_ = 3;
ymin_ = -2;
ymax_ = 3;

x_ = linspace(xmin_, xmax_, floor((xmax_ - xmin_)/ds));
y_ = linspace(ymin_, ymax_, floor(((ymax_ - ymin_))/ds));

[X, Y] = meshgrid(x_, y_);

Z = zeros(size(X));
for j = 1:length(x_)
    for i = 1:length(y_)
        coords = [X(i, j), Y(i, j)];
        Z(i, j) = oracle(coords);
    end
end

hfigs_states_xy = my_figure();
plot(sol(:, 1), sol(:, 2));
hold on;
plot(xhat_current(:, 1), xhat_current(:, 2));

hold on;
contour(X, Y, Z);

hold on;
plot(estimations(:, 1), estimations(:, 2), 'ko');
hold on;

for i = 1:length(trajs)
    trajs_i = trajs{i};
    plot(trajs_i(:, 1), trajs_i(:, 2), 'r--');
    hold on;
end

hold off;

xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');

axis square;
axis([xmin_, xmax_, ymin_, ymax_]);
grid;

% Speeds plot
plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = repeat_str('$t$ [s]', 2);
plot_info_p.ylabels = {'$\dot x$', '$\dot y$'};
plot_info_p.grid_size = [2, 1];

[n_s, ~] = size(sol);
[n_t, ~] = size(trajs_t);

n_min = min(n_s, n_t);

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
plot_info_traj.markers = {{'r--', 'b-'}, {'r--', 'b-'}};

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
