% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');
syms t T;

freedom_syms = [];
freedom_vals = [];

point_A.t = 0;
point_A.coords = [0; 0; 0; 0];

point_B.t = 1;
point_B.coords = [1; 1; pi/4; 0];

points = [point_A, point_B];

lambda = t/T;

interval = 1;
degree_interp = 3;

dy = point_B.coords(2) - point_A.coords(2);
dx = point_B.coords(1) - point_A.coords(1);

theta_x = atan2(dy, dx);
theta_1 = theta_x;
dist_2 = norm([dx; dy]);
theta_3 = point_B.coords(3);

% Time span
dt = 0.01;
time = 0:dt:interval;

wb = my_waitbar('Calculating speeds and states');

symbs = sys.descrip.syms;
model_params = sys.descrip.model_params;

% Inicialization
coords = [];
speeds = [];
state_speeds = [];
accels = [];

% Coordinates and speed update
for i = 1:length(time)
    t_i = time(i);
    
    [q_vals, p_vals, ...
     qp_vals, pp_vals, ...
     qpp_vals] = steering_smoothstep(t_i, ...
                                     interval_1, interval_2, interval_3, ...
                                     dt, degree_interp, symbs, ...
                                     model_params, points, sys);
    
    coords = [coords; q_vals'];
    speeds = [speeds; p_vals'];
    state_speeds = [state_speeds; qp_vals'];
    accels = [accels; pp_vals'];
        
    wb.update_waitbar(t_i, interval);
end

% wb.close_window();
% 
% plot_info.titles = repeat_str('', length(sys.kin.q));
% plot_info.xlabels = repeat_str('$t$ [s]', length(sys.kin.q));
% plot_info.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$'};
% plot_info.grid_size = [2, 2];
% 
% hfig_coords = my_plot(time, coords, plot_info);
% 
% plot_info.titles = repeat_str('', length(sys.kin.q));
% plot_info.xlabels = repeat_str('$t$ [s]', length(sys.kin.q));
% plot_info.ylabels = {'$\dot x$', '$\dot y$', ...
%                      '$\dot \theta$', '$\dot \phi$'};
% plot_info.grid_size = [2, 2];
% 
% hfig_states_speeds = my_plot(time, state_speeds, plot_info);
% 
% plot_info.titles = repeat_str('', length(sys.kin.p{end}));
% plot_info.xlabels = repeat_str('$t$ [s]', length(sys.kin.p{end}));
% plot_info.ylabels = {'$\omega_{\theta}$', '$\omega_{\phi}$'};
% plot_info.grid_size = [2, 1];
% 
% hfig_speeds = my_plot(time, speeds, plot_info);
% 
% plot_info.titles = repeat_str('', length(sys.kin.p{end}));
% plot_info.xlabels = repeat_str('$t$ [s]', length(sys.kin.p{end}));
% plot_info.ylabels = {'$\dot{\omega}_{\theta}$', '$\dot{\omega}_{\phi}$'};
% plot_info.grid_size = [2, 1];
% 
% hfig_accels = my_plot(time, accels, plot_info);
% 
% plot_info.titles = {'$x(t) \times y(t)$'};
% plot_info.xlabels = {'$x$'};
% plot_info.ylabels = {'$y$'};
% plot_info.grid_size = [1, 1];
% 
% hfig_coordsxy = my_plot(coords(:, 1), coords(:, 2), plot_info);
% 
% saveas(hfig_coords, './imgs/traj_smoothstep_states.eps', 'epsc');
% saveas(hfig_speeds, './imgs/traj_smoothstep_speeds.eps', 'epsc');
% saveas(hfig_states_speeds, './imgs/traj_smoothstep_states_speeds.eps', 'epsc');
% saveas(hfig_accels, './imgs/traj_smoothstep_accels.eps', 'epsc');
% saveas(hfig_coordsxy, './imgs/traj_smoothstep_coordsxy.eps', 'epsc');
