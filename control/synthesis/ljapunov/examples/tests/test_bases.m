clear all
close all
clc

run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');

traj_types = {'polynomial', 'exp', 'harmonic'};

syms t T;
dt = 0.01;

point_A.t = 0;
xA = 0;
yA = 0;
point_A.coords = [0; 0; 0; 0];

point_B.t = 1;
xB = 1;
yB = 1;
point_B.coords = [xB; yB; pi/2; 0];

points = [point_A, point_B];
lambda = t/T;
interval = 1;

qs_cells = {};
qps_cells = {};
qpps_cells = {};
ps_cells = {};
pps_cells = {};

for traj_type = traj_types
    traj_type = traj_type{1};

    [params_syms, ...
     params_sols, ...
     params_model] = gentrajmodel(sys, traj_type, interval, points);
    
    time = 0:dt:interval;
    
    wb = my_waitbar('Calculating speeds and states');

    coords = [];
    speeds = [];
    state_speeds = [];
    qpp_accels = [];
    pp_accels = [];
    
    for t = time
        [q_vals, p_vals, ...
         qp_vals, pp_vals, ...
         qpp_vals] = rolling_smooth(t, interval, params_model, ...
                                    params_syms, params_sols, ...
                                    dt, points, sys);
    
        coords = [coords; q_vals'];
        speeds = [speeds; p_vals'];
        state_speeds = [state_speeds; qp_vals'];
        qpp_accels = [qpp_accels; qpp_vals'];
        pp_accels = [pp_accels; pp_vals'];

        wb.update_waitbar(t, interval);
    end
    
    qs_cells{end+1} = coords;
    qps_cells{end+1} = state_speeds;
    qpps_cells{end+1} = qpp_accels;
    ps_cells{end+1} = speeds;
    pps_cells{end+1} = pp_accels;
    
    wb.close_window();
end

time = 0:dt:interval;

traj_types = {'polynomial', 'exponential', ...
              'Harmonic and polynomial functions'};

plot_info.titles = repeat_str('', 4);
plot_info.xlabels = repeat_str('$t$ [s]', 4);
plot_info.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$'};
plot_info.grid_size = [2, 2];
plot_info.legends = {traj_types, traj_types, traj_types, traj_types};
plot_info.pos_multiplots = [1, 2, 3, ...
                            1, 2, 3];
plot_info.markers = {{'-', '--', 'r.-'}, ...
                     {'-', '--', 'r.-'}, ...
                     {'-', '--', 'r.-'}, ...
                     {'-', '--', 'r.-'}};

qs_cells_head = qs_cells{1};
qs_cells_tail = [qs_cells{2}, qs_cells{3}];

hfig_qs = my_plot(time, {qs_cells_head, qs_cells_tail}, plot_info);

plot_info.titles = repeat_str('', 4);
plot_info.xlabels = repeat_str('$t$ [s]', 4);
plot_info.ylabels = {'$\dot x$', '$\dot y$', ...
                     '$\dot \theta$', '$\dot \phi$'};
plot_info.grid_size = [2, 2];
plot_info.legends = {traj_types, traj_types, traj_types, traj_types};
plot_info.pos_multiplots = [1, 2, 3, 4, ...
                            1, 2, 3, 4];
plot_info.markers = {{'-', '--', 'r.-'}, ...
                     {'-', '--', 'r.-'}, ...
                     {'-', '--', 'r.-'}, ...
                     {'-', '--', 'r.-'}};

qps_cells_head = qps_cells{1};
qps_cells_tail = [qps_cells{2}, qps_cells{3}];

hfig_qps = my_plot(time, {qps_cells_head, qps_cells_tail}, plot_info);

plot_info.titles = repeat_str('', 2);
plot_info.xlabels = repeat_str('$t$ [s]', 2);
plot_info.ylabels = {'$\omega_{\theta}$', '$\omega_{\phi}$'};
plot_info.grid_size = [2, 1];
plot_info.legends = {traj_types, traj_types};
plot_info.pos_multiplots = [1, 2, 1, 2];
plot_info.markers = {{'-', '--', 'r.-'}, ...
                     {'-', '--', 'r.-'}};

ps_cells_head = ps_cells{1};
ps_cells_tail = [ps_cells{2}, ps_cells{3}];

hfig_ps = my_plot(time, {ps_cells_head, ps_cells_tail}, plot_info);

plot_info.titles = repeat_str('', 2);
plot_info.xlabels = repeat_str('$t$ [s]', 2);
plot_info.ylabels = {'$\dot{\omega}_{\theta}$', ...
                     '$\dot{\omega}_{\phi}$'};
plot_info.grid_size = [2, 1];
plot_info.legends = {traj_types, traj_types};
plot_info.pos_multiplots = [1, 2, 1, 2];
plot_info.markers = {{'-', '--', 'r.-'}, ...
                     {'-', '--', 'r.-'}};

pps_cells_head = pps_cells{1};
pps_cells_tail = [pps_cells{2}, pps_cells{3}];

hfig_pps = my_plot(time, {pps_cells_head, pps_cells_tail}, plot_info);

hfig_trajs = my_figure();
plot(qs_cells{1}(:, 1), qs_cells{1}(:, 2), '-');
hold on;
plot(qs_cells{2}(:, 1), qs_cells{2}(:, 2), '--');
hold on;
plot(qs_cells{3}(:, 1), qs_cells{3}(:, 2), 'r.-');
hold off

legend(traj_types, 'interpreter', 'latex')
title('Trajectories on x-y plane', 'interpreter', 'latex');
xlabel('$x$', 'interpreter', 'latex');
ylabel('$y$', 'interpreter', 'latex');

saveas(hfig_qs, '../imgs/traj_smooth_states.eps', 'epsc');
saveas(hfig_qps, '../imgs/traj_smooth_dstates.eps', 'epsc');
saveas(hfig_qpps, '../imgs/traj_smooth_ddstates.eps', 'epsc');
saveas(hfig_ps, '../imgs/traj_smooth_speeds.eps', 'epsc');
saveas(hfig_pps, '../imgs/traj_smooth_accels.eps', 'epsc');
saveas(hfig_trajs, '../imgs/traj_smooth_trajs.eps', 'epsc');
