close all

% ----------- Reference plot -----------
vars = [];
for t_i = t
    vars = [vars; ref_func(t_i)'];
end

plot_info_q.titles = repeat_str('', 8);
plot_info_q.ylabels = {'$x$', '$y$', ...
                       '$\dot{x}$', '$\dot{y}$', ...
                       '$\ddot{x}$', '$\ddot{y}$', ...
                       '$x^{(3)}$', '$y^{(3)}$'};
plot_info_q.xlabels = repeat_str('$t$ [s]', 8);
plot_info_q.grid_size = [4, 2];

hfig_references = my_plot(t, vars, plot_info_q);

% --------------------------------------

% ----- States and reference plot ------

ref_vals = [];
for t_i = t
    ref_vals = [ref_vals; ref_func(t_i)'];
end

plot_config.titles = repeat_str('', 6);
plot_config.xlabels = [repeat_str('', 5), {'$t$ [s]'}];
plot_config.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$', ...
                       '$\omega_{\theta}$', '$\omega_{\phi}$'};
plot_config.legends = {{'$x$', '$x^{\star}$'}, {'$y$', '$y^{\star}$'}};
plot_config.grid_size = [3, 2];
plot_config.pos_multiplots = [1, 2];
plot_config.markers = {{'-', '--'}, {'-', '--'}};

states = sol(:, 1:end-1);

hfig_states = my_plot(t, {states, ref_vals(:, 1:2)}, plot_config);

% --------------------------------------

% -------------- x-y Plot --------------

plot_info_q.titles = repeat_str('', 1);
plot_info_q.ylabels = {'$x$'};
plot_info_q.xlabels = {'$y$'};
plot_info_q.grid_size = [1, 1];

hfig_statesxy = my_figure();
plot(states(:, 1), states(:, 2), '-');
hold on;
plot(ref_vals(:, 1), ref_vals(:, 2), '--');
hold off;
axis([-a a -b b]);
legend({'$r(t)$', '$r^{\star}(t)$'}, 'interpreter', 'latex')
xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');

axis equal;
axis([-2 2 -1 2]);

% --------------------------------------

% ----------- Errors plot --------------

e = x_sym(1:2) - y_ref;
e_func = @(t, q_p) subs(e, x_ref_sym, [q_p; ref_func(t)]);

errors_sim = [];
for i = 1:length(t)
    errors_sim = [errors_sim; e_func(t(i), sol(i, :)')'];
end

pos = [x_sym(1:2); dydt; d2ydt2];
pos_val = subs(pos, x_ref_sym, [sol(1, :)'; ref_func(0)]);

ref_ = [y_ref; yp_ref; ypp_ref];
ref_val = subs(ref_, x_ref_sym, [sol(1, :)'; ref_func(0)]);

errors = pos_val - ref_val;
e0 = subs(errors, x_ref_sym, [sol(1, :)'; ref_func(0)]);
e0 = [e0(1); e0(3); e0(5); e0(2); e0(4); e0(6)];

A1 = ctrb_canon(roots_1);
A2 = ctrb_canon(roots_2);

e_n = canon_Rn(length(roots_1), 1)';
C = blkdiag(e_n, e_n);

R_syms = sys.descrip.syms(2);
R_val = sys.descrip.model_params(2);
syms t_;
errors_t = [];
for t_i = t
    eAt = expm(blkdiag(A1, A2)*t_);
    CAte0 = subs(C*eAt*e0, [t_, R_syms], [t_i, R_val]);
    errors_t = [errors_t; CAte0'];
end

plot_config.titles = {'', ''};
plot_config.xlabels = {'', 't [s]'};
plot_config.ylabels = {'$e_x$', '$e_y$'};
plot_config.grid_size = [2, 1];
plot_config.legends = {{'Real', 'Expected'}, {'Real', 'Expected'}};
plot_config.pos_multiplots = [1, 2];
plot_config.markers = {{'-', '--'}, {'-', '--'}};

hfig_errors = my_plot(t', {errors_sim, errors_t}, plot_config);

% --------------------------------------

% ----------- Speed plot ---------------

plot_info_e.titles = repeat_str('', 2);
plot_info_e.ylabels = {'$\tau_{\theta}$', '$\tau_{\phi}$'};
plot_info_e.xlabels = repeat_str('$t$ [s]', 2);
plot_info_e.grid_size = [2, 1];

hfigs_u = my_plot(t(1:end-1), input_torque, plot_info_e);

C = sys.kin.C;
qp_x = subs(C*p, [q; p; z_1], x_sym);

symbs = sys.descrip.syms;
model_params = sys.descrip.model_params;

qp_t = [];
for i = 1:length(t)
    t_i = t(i);
    
    qp_t = [qp_t; ...
            subs(qp_x, ...
                 [x_sym; symbs.'], ...
                 [sol(i, :)'; model_params.'])'];
end

R_val = model_params(2);

qp_ref = [];
for i = 1:length(t)
    xp_yp_d = ref_vals(i, 3:4);
    xpp_ypp_d = ref_vals(i, 5:6);
    theta_d = atan2(xp_yp_d(2), xp_yp_d(1));
    v_d = norm(xp_yp_d);
    
    thetap_d = (-xpp_ypp_d(1)*sin(theta_d) + ...
                xpp_ypp_d(2)*cos(theta_d))/v_d;
    
    v = norm(xp_yp_d);
    phip_d = v/R_val;

    qp_ref = [qp_ref; xp_yp_d, thetap_d, phip_d];
end

plot_info_qp.titles = repeat_str('', 4);
plot_info_qp.ylabels = {'$\dot{x}$', '$\dot{y}$', ...
                        '$\dot{\theta}$', '$\dot{\phi}$'};
plot_info_qp.xlabels = [repeat_str('', 3), {'$t$ [s]'}];
plot_info_qp.legends = {{'$\dot{x}$', '$\dot{x}^{\star}$'}, ...
                       {'$\dot{y}$', '$\dot{y}^{\star}$'}, ...
                       {'$\dot{\theta}$', '$\dot{\theta}^{\star}$'}, ...
                       {'$\dot{\phi}$', '$\dot{\phi}^{\star}$'}};
plot_info_qp.pos_multiplots = [1, 2, 3, 4];
plot_info_qp.grid_size = [2, 2];
plot_info_qp.markers = {{'-', '--'}, {'-', '--'}, ...
                        {'-', '--'}, {'-', '--'}};

hfig_qpt = my_plot(t, {qp_t, qp_ref}, plot_info_qp);

% --------------------------------------

saveas(hfig_references, ['../imgs/references', ...
                         num2str(a), ...
                         num2str(b)], 'epsc');
saveas(hfig_states, ['../imgs/states', ...
                     num2str(a), ...
                     num2str(b)], 'epsc');
saveas(hfig_statesxy, ['../imgs/statesxy', ...
                       num2str(a), ...
                       num2str(b)], 'epsc');
saveas(hfig_errors, ['../imgs/errors', ...
                     num2str(a), ...
                     num2str(b)], 'epsc');
saveas(hfig_qpt, ['../imgs/dstates', ...
                  num2str(a), ...
                  num2str(b)], 'epsc');