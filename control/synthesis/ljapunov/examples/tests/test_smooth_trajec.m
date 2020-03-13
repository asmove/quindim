% % clear all
% % close all
% % clc
% % 
% % run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');
% syms t T;
% 
% syms a0 a1 a2
% syms b0 b1 b2
% 
% interval = 1;
% 
% thetas = 0:0.5:2*pi;
% 
% q_t = [];
% qp_t = [];
% qpp_t = [];
% p_t = [];
% pp_t = [];
% 
% tim_dev.q_s = {};
% tim_dev.qp_s = {};
% tim_dev.qpp_s = {};
% tim_dev.p_s = {};
% tim_dev.pp_s = {};
% 
% time_dev.q_s = {};
% time_dev.qp_s = {};
% time_dev.qpp_s = {};
% time_dev.p_s = {};
% time_dev.pp_s = {};
% 
% for idx = 1:length(thetas)
%     for idy = idx+1:length(thetas)
%         theta_head = thetas(idx);
%         theta_tail = thetas(idy);
%         
%         % as = [a0; a1; a2; a3; a4; a5];
%         % bs = [b0; b1; b2; b3; b4; b5];
%         as = [a0; a1; a2];
%         bs = [b0; b1; b2];
%         free_params = [as; bs];
% 
%         point_A.t = 0;
%         xA = 0;
%         yA = 0;
%         point_A.coords = [0; 0; theta_head; 0];
% 
%         point_B.t = 1;
%         xB = 1;
%         yB = 1;
%         point_B.coords = [xB; yB; theta_tail; 0];
% 
%         points = [point_A, point_B];
% 
%         lambda = t/T;
% 
%         x = a0 + a1*lambda + a2*lambda^2;
%         y = b0 + b1*lambda + b2*lambda^2;
% 
%         % x = a0 + a1*exp(lambda) + a2*exp(2*lambda);
%         % y = b0 + b1*exp(lambda) + b2*exp(2*lambda);
% 
%         freedom_syms = [];
%         freedom_vals = [];
% 
%         source_vars = sys.kin.q(1:2);
% 
%         q = sys.kin.q;
%         qp = sys.kin.qp;
% 
%         n_q = length(q);
% 
%         r = symvar(source_vars)';
% 
%         drdt = sys.kin.qp(1:2);
%         r_t = [x; y];
%         drdt_t = diff(r_t, t);
%         d2rdt2_t = diff(r_t, t);
%         d3rdt3_t = diff(r_t, t);
% 
%         dxdt = diff(x, t);
%         dydt = diff(y, t);
% 
%         constraints = sys.kin.A*sys.kin.qp;
% 
%         model_syms = sys.descrip.syms;
%         model_params = sys.descrip.model_params;
% 
%         eqs_bounds = [r - r_t];
%         eqs_constraints = constraints;
% 
%         r_syms = sym('r_', size(r));
%         rbar_syms = sym('rbar_', size(r));
% 
%         dr_syms = sym('dr_', size(r));
%         drbar_syms = sym('drbar_', size(r));
% 
%         symbs = [r; drdt; model_syms.'; freedom_syms];
%         params = [r_syms; dr_syms; model_params.'; freedom_vals];
% 
%         eqs_bounds_symbs = subs(eqs_bounds, symbs, params);
% 
%         rbar = q;
%         for i = 1:length(r_syms)
%             coords_i = r(i);
% 
%             coords_idxs = find(rbar == coords_i);
%             rbar(coords_idxs) = [];
%         end
% 
%         params_opt = free_params;
%         for i = 1:length(freedom_syms)
%             coords_i = freedom_syms(i);
% 
%             coords_idxs = find(params_opt == coords_i);
%             params_opt(coords_idxs) = [];
%         end
% 
%         drbar = dvecdt(rbar, q, qp);
% 
%         symbs = [r; drdt; rbar; drbar; model_syms.'; freedom_syms];
%         params = [r_t; drdt_t; r_syms; dr_syms; model_params.'; freedom_vals];    
% 
%         eqs_constraints_symbs = subs(eqs_constraints, symbs, params);
%         eqs_symbs = [eqs_bounds_symbs; eqs_constraints_symbs];
% 
%         symbs0 = [t; r_syms; dr_syms; rbar_syms; drbar_syms];
%         symbsT = [t; r_syms; dr_syms; rbar_syms; drbar_syms];
% 
%         vals0 = [0; ...
%                  sym('r0_', size(r)); 
%                  sym('dr0_', size(r)); ...
%                  sym('rbar0_', size(rbar)); ...
%                  sym('drbar0_', size(drbar))];
% 
%         valsT = [T; ...
%                  sym('rT_', size(r)); ...
%                  sym('drT_', size(r)); ...
%                  sym('rbarT_', size(rbar)); ...
%                  sym('drbarT_', size(drbar))];
% 
%         eqs_symbs_0 = subs(eqs_symbs, symbs0, vals0);
%         eqs_symbs_T = subs(eqs_symbs, symbsT, valsT);
% 
%         eqs_symbs_0T = [eqs_symbs_0; eqs_symbs_T];
% 
%         A_symbs = -equationsToMatrix(eqs_symbs_0T, params_opt);
%         b_symbs = simplify_(A_symbs*params_opt + eqs_symbs_0T);
% 
%         eqs_syms = [eqs_bounds; eqs_constraints];
% 
%         model_syms = sys.descrip.syms;
%         model_params = sys.descrip.model_params;
% 
%         q = sys.kin.q;
%         qp = sys.kin.qp;
%         
%         eqs = [];
%         for i = 1:length(points)
%             t_i = points(i).t;
%             coords = points(i).coords;
% 
%             coords_q = coords(1:n_q);
% 
%             r_vals = subs(r, q, coords_q);
%             drdt_vals = subs(drdt, q, coords_q);
% 
%             symbs = [r; drdt; model_syms.'; freedom_syms];
%             params = [r_vals; drdt_vals; model_params.'; freedom_vals];
%             eqs_bounds_i = subs(eqs_bounds, symbs, params);
% 
%             symbs = [q; drdt; model_syms.'; freedom_syms];
%             params = [coords_q; drdt_t; model_params.'; freedom_vals];    
%             eqs_constraints_i = subs(eqs_constraints, symbs, params);
% 
%             eqs_i = [eqs_bounds_i; eqs_constraints_i];
% 
%             symbs = [t; T];
%             params = [t_i; interval];
% 
%             eqs_i = subs(eqs_i, symbs, params);
% 
%             eqs = [eqs; eqs_i];
%         end
% 
%         eqs = subs(eqs, T, interval);
% 
%         A1 = sys.kin.As{1};
% 
%         % oracle = @(x) double(subs(norm(eqs), params_opt, x));
%         % params0 = rand(size(params_opt));
%         % 
%         % options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
%         % 
%         % problem.objective = oracle;
%         % problem.x0 = params0;
%         % problem.solver = 'fmincon';
%         % problem.options = options;
%         % 
%         % [sol, val] = fmincon(problem);
% 
%         A = -equationsToMatrix(eqs, params_opt);
%         b = simplify_(A*params_opt + eqs);
% 
%         b = subs(b, freedom_syms, freedom_vals);
% 
%         sol = A\b;
%     
%         symbs = [T; freedom_syms; params_opt];
%         vals = [interval; freedom_vals; sol];
% 
%         r_val = subs(r_t, symbs, vals);
%         drdt_val = subs(drdt_t, symbs, vals);
%         d2rdt2_val = subs(d2rdt2_t, symbs, vals);
%         d3rdt3_val = subs(d3rdt3_t, symbs, vals);
%         
%         % Useful parameters
%         R = sys.descrip.model_params(2);
%         EPS = 1e-5;
% 
%         % Inicialization
%         coords = [];
%         speeds = [];
%         state_speeds = [];
%         accels = [];
%         
%         wb = my_waitbar('Calculating speeds and states');
%         
%         q_s = [];
%         qp_s = [];
%         qpp_s = [];
%         p_s = [];
%         pp_s = [];
%         
%         % Time span
%         dt = 0.01;
%         time = 0:dt:interval;
%         
%         % Coordinates and speed update
%         for i = 1:length(time)
%             t_i = time(i);
% 
%             symbs = [t; T; freedom_syms; params_opt];
%             vals = [t_i; interval; freedom_vals; sol];
% 
%             [q_vals, p_vals, ...
%              qp_vals, pp_vals ...
%              qpp_vals] = rolling_smooth(t_i, interval, ...
%                                         r_t, params_opt, sol, ...
%                                         dt, points, sys);
% 
%             coords = [coords; q_vals'];
%             speeds = [speeds; p_vals'];
%             state_speeds = [state_speeds; qp_vals'];
%             qpp_accels = [accels; qpp_vals'];
%             pp_accels = [accels; pp_vals'];
% 
%             wb.update_waitbar(t_i, interval);
%         end
%         
%         wb.close_window();
%         
%         time_dev.q_s{end+1} = {{theta_head, theta_tail}, coords};
%         time_dev.qp_s{end+1} = {{theta_head, theta_tail}, state_speeds};
%         time_dev.qpp_s{end+1} = {{theta_head, theta_tail}, qpp_accels};
%         
%         time_dev.p_s{end+1} = {{theta_head, theta_tail}, speeds};
%         time_dev.pp_s{end+1} = {{theta_head, theta_tail}, pp_accels};
%     end
% end

hfig = my_figure();

for i = 1:length(time_dev.q_s)
    q_i = time_dev.q_s{i}{2};
    
    if(any(any(isnan(q_i))))
        thetas = time_dev.q_s{i}{1};
        msg = "Extremes (%.2f, %.2f) requires NaN trajectory!";
        disp(sprintf(msg, thetas(1), thetas(2)));
    end
        
    plot(q_i(:, 1), q_i(:, 2));
    hold on
end

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
% plot_config.titles = {'Harmonic', 'Exponential'};
% plot_config.xlabels = {'t [s]', 't [s]'};
% plot_config.ylabels = {'$y(t)$', '$y(t)$'};
% plot_config.grid_size = [2, 1];
% plot_config.legends = {'$\sin(x)$', '$\cos(x)$'};
% plot_config.pos_multiplots = 1;
% plot_config.markers = {'-', '--'};

% plot_info.titles = {'$x(t) \times y(t)$'};
% plot_info.xlabels = {'$x$'};
% plot_info.ylabels = {'$y$'};
% plot_info.grid_size = [1, 1];
% 
% hfig_coordsxy = my_plot(coords(:, 1), coords(:, 2), plot_info);
% 
% axis square;
% 
% % saveas(hfig_coords, '../imgs/traj_smooth_states.eps', 'epsc');
% % saveas(hfig_speeds, '../imgs/traj_smooth_speeds.eps', 'epsc');
% % saveas(hfig_states_speeds, '../imgs/traj_smooth_states_speeds.eps', 'epsc');
% % saveas(hfig_accels, '../imgs/traj_smooth_accels.eps', 'epsc');
% saveas(hfig_coordsxy, '../imgs/traj_smooth_coordsxy.eps', 'epsc');
