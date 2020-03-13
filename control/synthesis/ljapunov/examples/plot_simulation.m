close all

% Generalized coordinates
plot_info_q.titles = repeat_str('', 2);
plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$'};
plot_info_q.grid_size = [2, 1];

% States plot
hfigs_states = my_plot(time, sol(:, 1:2), plot_info_q);

% Generalized coordinates
plot_info_q.titles = repeat_str('', 5);
plot_info_q.xlabels = repeat_str('$t$ [s]', length(sys.kin.q));
plot_info_q.ylabels = {'$\mathcal{L}_f^v$', '$\mathcal{L}_{g_1}^v$', ...
                       '$\mathcal{L}_{g_2}^v$', '$\dot V$'};
plot_info_q.grid_size = [2, 2];

uparts = zeros(length(u_parts), 4);
for i = 1:length(u_parts)
    uparts(i, 1) = u_parts(i).L_f_v;
    uparts(i, 2) = u_parts(i).L_G_v(1)/norm(u_parts(i).L_G_v)^2;
    uparts(i, 3) = u_parts(i).L_G_v(2)/norm(u_parts(i).L_G_v)^2;
    uparts(i, 4) = u_parts(i).Vp;
end

% States plot
hfigs_uparts = my_plot(tu_s, uparts, plot_info_q);

% xy-coordinates
hfigs_states_xy = my_figure();
plot(sol(:, 1), sol(:, 2));
hold on;
plot(estimations(:, 1), estimations(:, 2), 'ko');
hold on;

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

hold on;

for i = 1:length(xhat_trajs)
    plot(xhat_trajs(i).x(:, 1), xhat_trajs(i).x(:, 2), ...
         'color', [0.8500, 0.3250, 0.0980]);
    hold on;
end

hold off;

xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');

axis square;
% axis([0, 1.5, 0, 1.5]);


plot_info_p.titles = repeat_str('', length(source_reference));
plot_info_p.xlabels = repeat_str('$t$ [s]', length(source_reference));
plot_info_p.ylabels = {'$\dot x$', '$\dot y$'};
plot_info_p.grid_size = [length(source_reference), 1];

% Speeds plot
hfigs_speeds = my_plot(time, sol(:, 3:4), plot_info_p);

plot_info_p.titles = repeat_str('', length(source_reference));
plot_info_p.xlabels = repeat_str('$t$ [s]', length(source_reference));
plot_info_p.ylabels = {'$\tau_{\theta}$', '$\tau_{\phi}$'};
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
plot_info_p.ylabels = {'$\dot{\hat{x}(t)}$', '$\dot{\hat{y}}(t)$'};
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
plot_info_p.ylabels = {'$\dot{\hat{p_1}}(t)$', '$\dot{\hat{p_2}}(t)$'};
plot_info_p.grid_size = [length(source_reference), 1];

hfigs_pphat = my_plot(tt, pphat_t, plot_info_p);

saveas(hfigs_states, './imgs/states.eps', 'epsc');
saveas(hfigs_uparts, './imgs/uparts.eps', 'epsc');
saveas(hfigs_states_xy, './imgs/states_xy.eps', 'epsc');
saveas(hfigs_speeds, './imgs/speeds.eps', 'epsc');
saveas(hfigs_u, './imgs/control.eps', 'epsc');
saveas(hfigs_readings, './imgs/readings.eps', 'epsc');
saveas(hfigs_ljapunov, './imgs/ljapunov.eps', 'epsc');
saveas(hfigs_xhat, './imgs/xhats.eps', 'epsc');
saveas(hfigs_xphat, './imgs/xphats.eps', 'epsc');
saveas(hfigs_phat, './imgs/phats.eps', 'epsc');
saveas(hfigs_pphat, './imgs/pphats.eps', 'epsc');