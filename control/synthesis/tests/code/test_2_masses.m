% clear all
% close all
% clc

% run('~/github/Robotics4fun/examples/2_masses/code/main.m');
% 
% % Params and parameters estimation
% model_params = sys.descrip.model_params.';
% perc = 0;
% imprecision = perc*ones(size(sys.descrip.syms))';
% params_lims = [(1-imprecision).*model_params, ...
%                (1+imprecision).*model_params];

% Control action
eta = 1;
poles = [-5, -5];
u = sliding_underactuated(sys, eta, poles, params_lims);

len_params = length(sys.descrip.model_params);

x0 = [1; 1; 1; 1];

mdlname = 'sliding_mode_MIMO';
tf = num2str(tf);

simOut = sim(mdlname, 'SaveOutput','on','OutputSaveName','sim_out', ...
                      'SimulationMode','normal','AbsTol','1e-10', ...
                      'StopTime', tf);

% Plot part
img_path = '../imgs/';

xref = simOut.get('x_ref');
x = simOut.get('x');
u_ = simOut.get('u');
s = simOut.get('s');
t = simOut.get('tout');

n = length([sys.kin.q; sys.kin.p]);

% Reference plot
plot_config.titles = repeat_str('', n + n/2);
plot_config.xlabels = repeat_str('', n + n/2);
plot_config.ylabels = {'$x_1^d$ [m]', '$\dot{x}_1^d$ [m/s]', ...
                       '$\ddot{x}_1^d$ [m/$s^2$]', ...
                       '$x_2^d$ [m]', '$\dot{x}_2^d$ [m/s]', ...
                       '$\ddot{x}_2^d$ [m/$s^2$]'};
plot_config.grid_size = [2, 3];

xref = xref.Data;
xref = [xref(:, 1), xref(:, 3), xref(:, 5), ...
        xref(:, 2), xref(:, 4), xref(:, 6)];

hfigs_xref = my_plot(t, xref, plot_config);

% Input plot 
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u$ [N]'};
plot_config.grid_size = [1, 1];

u_ = u_.Data;

hfigs_u = my_plot(t, u_, plot_config);

% States plot
plot_config.titles = repeat_str('', n);
plot_config.xlabels = repeat_str('t [s]', n);
plot_config.ylabels = {'$x_1$ [m]', '$\dot{x}_1$ [m/s]', ...
                       '$x_2$ [m]', '$\dot{x}_2$ [m/s]'};
plot_config.grid_size = [2, 2];

x = x.Data;
x = [x(:, 1), x(:, 3), x(:, 2), x(:, 4)];

hfigs_x = my_plot(t, x, plot_config);

% Sliding function plot
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'Sliding function s'};
plot_config.grid_size = [1, 1];

s = s.Data;

hfigs_s = my_plot(t, s, plot_config);

% Reference
saveas(hfigs_xref, '../imgs/xref.eps', 'eps');

% States
saveas(hfigs_x, '../imgs/x.eps', 'eps');

% States
saveas(hfigs_u, '../imgs/u.eps', 'eps');

% Sliding function
saveas(hfigs_s, '../imgs/s.eps', 'eps');