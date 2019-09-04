% clear all
% close all
% clc

% run('~/github/Robotics4fun/examples/2_masses/code/main.m');

% Params and parameters estimation
model_params = sys.descrip.model_params.';
perc = 10/100;
precision = perc*ones(size(sys.descrip.syms))';
params_lims = [(1-precision).*model_params, ...
               (1+precision).*model_params];

% Control action
u = sliding_underactuated(sys, 1, [-5, -5], params_lims);

len_params = length(sys.descrip.model_params);

plant = subs(sys.dyn.f + sys.dyn.G*sys.descrip.u, ...
             sys.descrip.syms.', model_params);

% x0 = [0; 1; 0; 1];
% 
% mdlname = 'sliding_mode_MIMO';
% 
% simOut = sim(mdlname, 'SaveOutput','on','OutputSaveName','sim_out', ...
%                       'SimulationMode','normal','AbsTol','1e-5', ...
%                       'StopTime', num2str(tf));
% 
% % Plot part
% img_path = '../imgs/';
% 
% xref = simOut.get('x_ref');
% x = simOut.get('x');
% u_ = simOut.get('u');
% s = simOut.get('s');
% t = simOut.get('tout');
% 
% % Reference plot
% plot_config.titles = {'', '', '', ''};
% plot_config.xlabels = {'t [s]', 't [s]', 't [s]', 't [s]'};
% plot_config.ylabels = {'$\theta_0^d$ [rad]', '$\dot{\theta}_0^d$ [rad]', ...
%                        '$\theta_1^d$ [rad]', '$\dot{\theta}_1^d$ [rad]'};
% plot_config.grid_size = [2, 2];
%                    
% xref = xref.Data;
% 
% hfigs_xref = my_plot(t, xref, plot_config);
% 
% % Input plot 
% plot_config.titles = {''};
% plot_config.xlabels = {'t [s]'};
% plot_config.ylabels = {'$\tau$ [N.m]'};
% plot_config.grid_size = [2, 2];
% 
% u_ = u_.Data;
% 
% hfigs_yref = my_plot(t, u_, plot_config);
% 
% % States plot
% plot_config.titles = {'', '', '', ''};
% plot_config.xlabels = {'t [s]', 't [s]', 't [s]', 't [s]'};
% plot_config.ylabels = {'$\theta_0$ [rad]', '$\dot{\theta}_0$ [rad]', ...
%                        '$\theta_1$ [rad]', '$\dot{\theta}_1$ [rad]'};
% plot_config.grid_size = [2, 2];
% 
% x = x.Data;
% 
% hfigs_y = my_plot(t, x, plot_config);
% 
% % States plot
% plot_config.titles = {'', '', '', ''};
% plot_config.xlabels = {'t [s]', 't [s]', 't [s]', 't [s]'};
% plot_config.ylabels = {'$\theta_0 - \theta_0^d$ [rad]', ...
%                        '$\dot{\theta}_0 - \dot{\theta}_0^d$ [rad]', ...
%                        '$\theta_1 - \theta_1^d$ [rad]', ...
%                        '$\dot{\theta}_1 - \dot{\theta}_1^d$ [rad]'};
% plot_config.grid_size = [2, 2];
% 
% error = x - xref;
% 
% hfigs_y = my_plot(t, error, plot_config);
% 
% % Sliding function plot
% plot_config.titles = {'', '', '', ''};
% plot_config.xlabels = {'t [s]'};
% plot_config.ylabels = {'Sliding function s'};
% plot_config.grid_size = [1, 1];
% 
% s = s.Data;
% 
% hfig_s = my_pl% x0 = [0; pi; 0; 0];
% 
% mdlname = 'sliding_mode_MIMO';
% 
% simOut = sim(mdlname, 'SaveOutput','on','OutputSaveName','sim_out', ...
%                       'SimulationMode','normal','AbsTol','1e-5', ...
%                       'StopTime', num2str(tf));
% 
% % Plot part
% img_path = '../imgs/';
% 
% xref = simOut.get('x_ref');
% x = simOut.get('x');
% u_ = simOut.get('u');
% s = simOut.get('s');
% t = simOut.get('tout');
% 
% % Reference plot
% plot_config.titles = {'', '', '', ''};
% plot_config.xlabels = {'t [s]', 't [s]', 't [s]', 't [s]'};
% plot_config.ylabels = {'$\theta_0^d$ [rad]', '$\dot{\theta}_0^d$ [rad]', ...
%                        '$\theta_1^d$ [rad]', '$\dot{\theta}_1^d$ [rad]'};
% plot_config.grid_size = [2, 2];
%                    
% xref = xref.Data;
% 
% hfigs_xref = my_plot(t, xref, plot_config);
% 
% % Input plot 
% plot_config.titles = {''};
% plot_config.xlabels = {'t [s]'};
% plot_config.ylabels = {'$\tau$ [N.m]'};
% plot_config.grid_size = [2, 2];
% 
% u_ = u_.Data;
% 
% hfigs_yref = my_plot(t, u_, plot_config);
% 
% % States plot
% plot_config.titles = {'', '', '', ''};
% plot_config.xlabels = {'t [s]', 't [s]', 't [s]', 't [s]'};
% plot_config.ylabels = {'$\theta_0$ [rad]', '$\dot{\theta}_0$ [rad]', ...
%                        '$\theta_1$ [rad]', '$\dot{\theta}_1$ [rad]'};
% plot_config.grid_size = [2, 2];
% 
% x = x.Data;
% 
% hfigs_y = my_plot(t, x, plot_config);
% 
% % States plot
% plot_config.titles = {'', '', '', ''};
% plot_config.xlabels = {'t [s]', 't [s]', 't [s]', 't [s]'};
% plot_config.ylabels = {'$\theta_0 - \theta_0^d$ [rad]', ...
%                        '$\dot{\theta}_0 - \dot{\theta}_0^d$ [rad]', ...
%                        '$\theta_1 - \theta_1^d$ [rad]', ...
%                        '$\dot{\theta}_1 - \dot{\theta}_1^d$ [rad]'};
% plot_config.grid_size = [2, 2];
% 
% error = x - xref;
% 
% hfigs_y = my_plot(t, error, plot_config);
% 
% % Sliding function plot
% plot_config.titles = {'', '', '', ''};
% plot_config.xlabels = {'t [s]'};
% plot_config.ylabels = {'Sliding function s'};
% plot_config.grid_size = [1, 1];
% 
% s = s.Data;
% 
% hfig_s = my_plot(t, s, plot_config);
% 
% % Reference
% saveas(hfigs_xref, ['../imgs/xref_', num2str(item), '.eps'], 'eps');
% 
% % States
% saveas(hfigs_x, ['../imgs/x_', num2str(item), '.eps'], 'eps');
% 
% % Sliding function
% saveas(hfigs_s, ['../imgs/s', num2str(item), '.eps'], 'eps');ot(t, s, plot_config);
% 
% % Reference
% saveas(hfigs_xref, ['../imgs/xref_', num2str(item), '.eps'], 'eps');
% 
% % States
% saveas(hfigs_x, ['../imgs/x_', num2str(item), '.eps'], 'eps');
% 
% % Sliding function
% saveas(hfigs_s, ['../imgs/s', num2str(item), '.eps'], 'eps');