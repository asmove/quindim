% Params and parameters estimation
model_params = sys.descrip.model_params.';

if(is_imprecise)
    imprecision = [0.99; 0.1; 0.2; 0];
else
    imprecision = [0; 0; 0; 0];
end

params_lims = [(1-imprecision).*model_params, ...
               (1+imprecision).*model_params];

rel_qqbar = sys.kin.q;

n = length(sys.kin.q);

% Control action
eta = 10*ones(n, 1);
poles = -10*ones(n, 1);
u = sliding_underactuated(sys, eta, poles, ...
                          params_lims, rel_qqbar, switch_type);



% len_params = length(sys.descrip.model_params);
% 
% % Initial values
% x0 = [0; 0.1];
% 
% % Tracking values
% A = 0.1;
% w = 2*pi*100;
% q_p_ref_fun = @(t) [A*sin(w*t)/w; A*cos(w*t); -A*w*sin(w*t)];
% 
% % Initial conditions
% tf = 1e-2;
% dt = 1e-4;
% 
% tspan = 0:dt:tf;
% df_h = @(t, x) df_sys(t, x, q_p_ref_fun, u, sys, tf);
% 
% u_func = @(t, x) output_sliding(t, x, q_p_ref_fun, ...
%                                 u, sys, tf);
% 
% sol = validate_model(sys, tspan, x0, u_func, false);
% x = sol';
% 
% [m, ~] = size(sys.dyn.Z);
% 
% % Plot part
% img_path = '../imgs/';
% 
% t_len = length(tspan);
% 
% q_p_s = [sys.kin.q; sys.kin.p];
% q_p_d_s = add_symsuffix([q_p_s; sys.kin.pp], '_d');
% 
% [~, m] = size(sys.dyn.Z);
% 
% q_p = [sys.kin.q; sys.kin.p];
% n = length(q_p);
% 
% % States plot
% plot_config.titles = repeat_str('', n);
% plot_config.xlabels = repeat_str('t [s]', n);
% plot_config.ylabels = {'$Q$ [C]', '$i$ [A]'};
% plot_config.grid_size = [1, 2];
% 
% hfigs_x = my_plot(tspan, x, plot_config);
% 
% % Input plot
% plot_config.titles = {'', ''};
% plot_config.xlabels = {'t [s]'};
% plot_config.ylabels = {'$u$ [V]'};
% plot_config.grid_size = [1, 1];
% 
% t_ = linspace(0, tf, length(u_control))';
% hfigs_u = my_plot(t_, u_control, plot_config);
% 
% % Sliding function plot
% plot_config.titles = {''};
% plot_config.xlabels = {'t [s]'};
% plot_config.ylabels = {'Sliding function $s$'};
% plot_config.grid_size = [1, 1];
% 
% s = [];
% 
% alpha_ = u.alpha;
% lambda = u.lambda;
% 
% t_ = linspace(0, tf, length(sliding_s))';
% hfigs_s = my_plot(t_, sliding_s, plot_config);
% 
% if(is_sat)
%     is_sat_str = '_sat';
% else
%     is_sat_str = '_deg';
% end
% 
% % States
% saveas(hfigs_x, ['../imgs/x_', int2str(phi), is_sat_str, '.eps'], 'epsc');
% 
% % States
% saveas(hfigs_u, ['../imgs/u_', int2str(phi), is_sat_str, '.eps'], 'epsc');
% 
% % Sliding function
% saveas(hfigs_s, ['../imgs/s_', int2str(phi), is_sat_str, '.eps'], 'epsc');
