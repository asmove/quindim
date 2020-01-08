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
point_B.coords = [1; 1; 0; 0];

points = [point_A, point_B];

lambda = t/T;

interval = 1;
degree_interp = 2;

% Time span
dt = 0.01;
time = 0:dt:interval;

wb = my_waitbar('Calculating speeds and states');

% Useful parameters
R = sys.descrip.model_params(2);

% Inicialization
coords = [];
speeds = [];
state_speeds = [];
accels = [];

% Coordinates and speed update
for i = 1:length(time)
    t_i = time(i);
    
    symbs = [t; T];
    vals = [t_i; interval];
    
    [q_vals, p_vals, ...
     qp_vals, pp_vals] = rolling_smoothstep(t_i, interval, degree_interp, ...
                                            model_params, dt, points);
                       
    coords = [coords; q_vals'];
    speeds = [speeds; p_vals'];
    state_speeds = [state_speeds; qp_vals'];
    accels = [accels; pp_vals'];
        
    wb.update_waitbar(t_i, interval);
end

wb.close_window();

plot_info.titles = repeat_str('', length(sys.kin.q));
plot_info.xlabels = repeat_str('$t$ [s]', length(sys.kin.q));
plot_info.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$'};
plot_info.grid_size = [2, 2];

hfig_coords = my_plot(time, coords, plot_info);

plot_info.titles = repeat_str('', length(sys.kin.q));
plot_info.xlabels = repeat_str('$t$ [s]', length(sys.kin.q));
plot_info.ylabels = {'$\dot x$', '$\dot y$', ...
                     '$\dot \theta$', '$\dot \phi$'};
plot_info.grid_size = [2, 2];

hfig_states_speeds = my_plot(time, state_speeds, plot_info);

plot_info.titles = repeat_str('', length(sys.kin.p{end}));
plot_info.xlabels = repeat_str('$t$ [s]', length(sys.kin.p{end}));
plot_info.ylabels = {'$\omega_{\theta}$', '$\omega_{\phi}$'};
plot_info.grid_size = [2, 1];

hfig_speeds = my_plot(time, speeds, plot_info);

plot_info.titles = repeat_str('', length(sys.kin.p{end}));
plot_info.xlabels = repeat_str('$t$ [s]', length(sys.kin.p{end}));
plot_info.ylabels = {'$\dot{\omega}_{\theta}$', '$\dot{\omega}_{\phi}$'};
plot_info.grid_size = [2, 1];

hfig_accels = my_plot(time, accels, plot_info);

plot_info.titles = {'$x(t) \times y(t)$'};
plot_info.xlabels = {'$x$'};
plot_info.ylabels = {'$y$'};
plot_info.grid_size = [1, 1];

hfig_coordsxy = my_plot(coords(:, 1), coords(:, 2), plot_info);

saveas(hfig_coords, './imgs/traj_states.eps', 'epsc');
saveas(hfig_speeds, './imgs/traj_speeds.eps', 'epsc');
saveas(hfig_states_speeds, './imgs/traj_states_speeds.eps', 'epsc');
saveas(hfig_accels, './imgs/traj_accels.eps', 'epsc');
saveas(hfig_coordsxy, './imgs/traj_coordsxy.eps', 'epsc');
