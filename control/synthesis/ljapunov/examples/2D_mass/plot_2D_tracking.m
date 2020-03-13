close all

% Generalized coordinates
plot_info_q.titles = repeat_str('', 2);
plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$'};
plot_info_q.grid_size = [2, 1];

% States plot
hfigs_states = my_plot(time, sol(:, 1:2), plot_info_q);

% xy-coordinates
ref_traj = [];
for i = 1:length(time)
    ref_traj_i = ref_func(time(i));
    ref_traj = [ref_traj; ref_traj_i'];
end

hfigs_states_xy = my_figure();
plot(sol(:, 1), sol(:, 2));
hold on
plot(ref_traj(:, 1), ref_traj(:, 2), '--');
hold off;

xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');

axis square;

plot_info_p.titles = repeat_str('', length(sys.kin.qp));
plot_info_p.xlabels = repeat_str('$t$ [s]', length(sys.kin.qp));
plot_info_p.ylabels = {'$\dot x$', '$\dot y$'};
plot_info_p.grid_size = [length(sys.kin.qp), 1];

% Speeds plot
hfigs_speeds = my_plot(time, sol(:, 3:4), plot_info_p);

plot_info_p.titles = repeat_str('', length(sys.kin.qp));
plot_info_p.xlabels = repeat_str('$t$ [s]', length(sys.kin.qp));
plot_info_p.ylabels = {'$F_x$', '$F_y$'};
plot_info_p.grid_size = [length(sys.kin.qp), 1];

% Control plot
hfigs_u = my_plot(tV_s, us, plot_info_p);

model_params = sys.descrip.model_params;
syms_plant = sys.descrip.syms;

% Readings plot
plot_info_p.titles = {''};
plot_info_p.xlabels = {'$t$ [s]'};
plot_info_p.ylabels = {'Ljapunov function $V(q, p)$'};
plot_info_p.grid_size = [1, 1];

hfigs_ljapunov = my_plot(tV_s, V_terms, plot_info_p);

saveas(hfigs_states, './imgs/states.eps', 'epsc');
saveas(hfigs_states_xy, './imgs/states_xy.eps', 'epsc');
saveas(hfigs_speeds, './imgs/speeds.eps', 'epsc');
saveas(hfigs_u, './imgs/output.eps', 'epsc');
saveas(hfigs_ljapunov, './imgs/ljapunov.eps', 'epsc');

