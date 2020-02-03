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

[n, ~] = size(estimations);

for i = 1:length(xhat_trajs)
    plot(xhat_trajs(i).x(:, 1), xhat_trajs(i).x(:, 2), ...
         'color', [0.8500, 0.3250, 0.0980]);
    hold on;
end

hold off;

xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');

axis square;

plot_info_p.titles = repeat_str('', length(source_reference));
plot_info_p.xlabels = repeat_str('$t$ [s]', length(source_reference));
plot_info_p.ylabels = {'$\dot x$', '$\dot y$'};
plot_info_p.grid_size = [length(source_reference), 1];

% Speeds plot
hfigs_speeds = my_plot(time, sol(:, 3:4), plot_info_p);

plot_info_p.titles = repeat_str('', length(source_reference));
plot_info_p.xlabels = repeat_str('$t$ [s]', length(source_reference));
plot_info_p.ylabels = {'$F_x$', '$F_y$'};
plot_info_p.grid_size = [length(source_reference), 1];

% Control plot
hfigs_u = my_plot(tu_s, u_s, plot_info_p);

plot_info_p.titles = {''};
plot_info_p.xlabels = {'$t$ [s]'};
plot_info_p.ylabels = {'Sinal de campo [ ]'};
plot_info_p.grid_size = [1, 1];

% Readings plot
hfigs_readings = my_plot(t_readings, readings, plot_info_p);

model_params = sys.descrip.model_params;
syms_plant = sys.descrip.syms;

t_V = time(1:end-1);
Vs = eval_ljapunov(t_V, sys, sol, xhat_t, phat_t, source_reference, P);

% Readings plot
plot_info_p.titles = {''};
plot_info_p.xlabels = {'$t$ [s]'};
plot_info_p.ylabels = {'Ljapunov function $V(q, p)$'};
plot_info_p.grid_size = [1, 1];

hfigs_ljapunov = my_plot(t_V, Vs, plot_info_p);

% Estimations plot
plot_info_p.titles = repeat_str('', length(source_reference));
plot_info_p.xlabels = repeat_str('$t$ [s]', length(source_reference));
plot_info_p.ylabels = {'$\hat{x}(t)$', '$\hat{y}(t)$'};
plot_info_p.grid_size = [length(source_reference), 1];

tt = linspace(time(1), time(end), length(phat_t));
hfigs_xhat = my_plot(tt, xhat_t, plot_info_p);

% Estimations plot
plot_info_p.titles = repeat_str('', length(source_reference));
plot_info_p.xlabels = repeat_str('$t$ [s]', length(source_reference));
plot_info_p.ylabels = {'$\dot{\hat{x}}(t)$', '$\dot{\hat{y}}(t)$'};
plot_info_p.grid_size = [length(source_reference), 1];

hfigs_xphat = my_plot(tt, xphat_t, plot_info_p);

% Estimation speed plot
plot_info_p.titles = repeat_str('', length(source_reference));
plot_info_p.xlabels = repeat_str('$t$ [s]', length(source_reference));
plot_info_p.ylabels = {'$\hat{p_1}(t)$', '$\hat{p_2}(t)$'};
plot_info_p.grid_size = [length(source_reference), 1];

hfigs_phat = my_plot(tt, phat_t, plot_info_p);

plot_info_p.titles = repeat_str('', length(source_reference));
plot_info_p.xlabels = repeat_str('$t$ [s]', length(source_reference));
plot_info_p.ylabels = {'$\dot{\hat{p}}_1(t)$', '$\dot{\hat{p}}_2(t)$'};
plot_info_p.grid_size = [length(source_reference), 1];

hfigs_pphat = my_plot(tt, pphat_t, plot_info_p);

plot_info.titles = {'V terms'};
plot_info.xlabels = {'$t$ [s]'};
plot_info.ylabels = {'V terms'};
plot_info.grid_size = [1, 1];
plot_info.legends = {{'$V(x)$', '$V(x)$ - p term', '$V(x)$ - q term'}};
plot_info.pos_multiplots = [1, 1];
plot_info.markers = {{'k-', 'm--', 'b.-'}};

hfigs_Vs = my_plot(tV_s, ...
                   {V_pterms + V_qterms, [V_pterms, V_qterms]}, ...
                   plot_info);

saveas(hfigs_states, './imgs/states.eps', 'epsc');
saveas(hfigs_states_xy, './imgs/states_xy.eps', 'epsc');
saveas(hfigs_speeds, './imgs/speeds.eps', 'epsc');
saveas(hfigs_Vs, './imgs/ljapunov_contributions.eps', 'epsc');
saveas(hfigs_u, './imgs/output.eps', 'epsc');
saveas(hfigs_readings, './imgs/readings.eps', 'epsc');
saveas(hfigs_ljapunov, './imgs/ljapunov.eps', 'epsc');
saveas(hfigs_xhat, './imgs/xhats.eps', 'epsc');
saveas(hfigs_xphat, './imgs/xphats.eps', 'epsc');
saveas(hfigs_phat, './imgs/phats.eps', 'epsc');
saveas(hfigs_pphat, './imgs/pphats.eps', 'epsc');

