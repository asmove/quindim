% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/2_masses/code/main.m');
% 
% % Params and parameters estimation
% model_params = sys.descrip.model_params.';
% perc = 0;
% imprecision = perc*ones(size(sys.descrip.syms))';
% params_lims = [(1-imprecision).*model_params, ...
%                (1+imprecision).*model_params];
% 
% % Control action
% eta = 1;
% poles = [-5, -5];
% u = sliding_underactuated(sys, eta, poles, params_lims);
% 
% len_params = length(sys.descrip.model_params);

x0 = [1; 1; 1; 1];

mdlname = 'sliding_mode_MIMO';
tf = num2str(3);

simOut = sim(mdlname, 'SaveOutput','on','OutputSaveName','sim_out', ...
                      'SimulationMode','normal','AbsTol','1e-5', ...
                      'StopTime', tf, 'FixedStep','0.0001');

% Plot part
img_path = '../imgs/';

xref = simOut.get('x_ref');
x = simOut.get('x');
u_ = simOut.get('u');
s = simOut.get('s');

n = length([sys.kin.q; sys.kin.p]);

% Reference plot
plot_config.titles = repeat_str('', n + n/2);
plot_config.xlabels = repeat_str('', n + n/2);
plot_config.ylabels = {'$x_1^d$ [m]', '$\dot{x}_1^d$ [m/s]', ...
                       '$\ddot{x}_1^d$ [m/$s^2$]', ...
                       '$x_2^d$ [m]', '$\dot{x}_2^d$ [m/s]', ...
                       '$\ddot{x}_2^d$ [m/$s^2$]'};
plot_config.grid_size = [2, 3];

t = xref.time;
xref_ = xref.Data;
xref_ = [xref_(:, 1), xref_(:, 3), xref_(:, 5), ...
        xref_(:, 2), xref_(:, 4), xref_(:, 6)];

hfigs_xref = my_plot(t, xref_, plot_config);

% Input plot 
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u$ [N]'};
plot_config.grid_size = [1, 1];

control_ = u_.Data;

hfigs_u = my_plot(t, control_, plot_config);

% States plot
plot_config.titles = repeat_str('', n);
plot_config.xlabels = repeat_str('t [s]', n);
plot_config.ylabels = {'$x_1$ [m]', '$\dot{x}_1$ [m/s]', ...
                       '$x_2$ [m]', '$\dot{x}_2$ [m/s]'};
plot_config.grid_size = [2, 2];

t = x.time;
x_ = x.Data;
x_ = [x_(:, 1), x_(:, 3), x_(:, 2), x_(:, 4)];

hfigs_x = my_plot(t, x_, plot_config);

% Sliding function plot
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'Sliding function s'};
plot_config.grid_size = [1, 1];

t = s.time;
sliding  = s.Data;

hfigs_s = my_plot(t, sliding, plot_config);

close all

x = [sys.kin.q; sys.kin.p];
x_d = add_symsuffix([sys.kin.q; sys.kin.p; sys.kin.pp], '_d');

x_xd = [x; x_d];

x1 = x_xd(1);
x2 = x_xd(2);
p1 = x_xd(3);
p2 = x_xd(4);
x1_d = x_xd(5);
x2_d = x_xd(6);
p1_d = x_xd(7);
p2_d = x_xd(8);
pp1_d = x_xd(9);
pp2_d = x_xd(10);

s = 0.1959698194110668922895968080411*p1 - ...
    0.0038042089050449481683890962102623*p2 - ...
    0.1959698194110668922895968080411*p1_d + ...
    0.0038042089050449481683890962102623*p2_d + ...
    0.97984909705533451695913527146331*x1 + ...
    0.038433122101204394244115641433587*x2 - ...
    0.97984909705533451695913527146331*x1_d - ...
    0.038433122101204394244115641433587*x2_d;

[m, n] = size(xref.Data);

sp_n = zeros(m, 1);
s_n = zeros(m, 1);
for i = 1:m
    xref_i = xref_(i, :);
    x_i = x_(i, :);
    x_xref_i = [x_i, xref_i]';
    
    s_n(i) = double(subs(s, x_xd, x_xref_i));
    sp_n(i) = - 1.0*sign(s_n(i));
end

figure();
plot(t, sp_n)

figure();
plot(t, s_n)

sol = ode45(@(t, s) -eta*sign(s), [0, 1], s_n(1));

figure();
plot(sol.x, sol.y);

% % Reference
% saveas(hfigs_xref, '../imgs/xref.eps', 'eps');
% 
% % States
% saveas(hfigs_x, '../imgs/x.eps', 'eps');
% 
% % States
% saveas(hfigs_u, '../imgs/u.eps', 'eps');
% 
% % Sliding function
% saveas(hfigs_s, '../imgs/s.eps', 'eps');