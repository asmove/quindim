close all

% ----------- Reference plot -----------
vars = [];
for i = 1:length(t)
    vars = [vars; ref_func(t(i))'];
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
for i = 1:length(t)
    ref_vals = [ref_vals; ref_func(t(i))'];
end

plot_config.titles = repeat_str('', 6);
plot_config.xlabels = [repeat_str('', 5), {'$t$ [s]'}];
plot_config.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$'};
plot_config.legends = {{'$x$', '$x^{\star}$'}, {'$y$', '$y^{\star}$'}};
plot_config.grid_size = [2, 2];
plot_config.pos_multiplots = [1, 2];
plot_config.markers = {{'-', '--'}, {'-', '--'}};

states = sol';
t = t';

hfig_states = my_plot(t, {states(:, 1:4), ref_vals(:, 1:2)}, plot_config);

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
axis([-1 1.5 -1 1   ]);
legend({'$r(t)$', '$r^{\star}(t)$'}, 'interpreter', 'latex')
xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');

axis equal;
axis([-1 1.5 -1 1   ]);

% --------------------------------------

syms xppp yppp;

y_ref = add_symsuffix(sys.kin.q(1:2), '_ref');
yp_ref = add_symsuffix(sys.kin.qp(1:2), '_ref');
ypp_ref = add_symsuffix(sys.kin.qpp(1:2), '_ref');
yppp_ref = add_symsuffix([xppp; yppp], '_ref');

x_sym = sym('x_', [7, 1]);
C = sys.kin.C;
q = sys.kin.q;
p = sys.kin.p{end};
v = sym('v', [2, 1]);
z_1 = sym('z_1');
ref_sym = [y_ref; yp_ref; ypp_ref; yppp_ref];
x_ref_sym = [x_sym; ref_sym];

% ----------- Errors plot --------------

e = x_sym(1:2) - y_ref;

e_func = @(t, q_p) subs(e, x_ref_sym, [q_p; ref_func(t)]);

errors_sim = [];
for i = 1:length(t)
    errors_sim = [errors_sim; e_func(t(i), sol(:, i))'];
end

% Output equations
y1 = sys.kin.q(1);
y2 = sys.kin.q(2);

symbs = sys.descrip.syms;
model_params = sys.descrip.model_params;

% First derivative for outputs
dy1dt = simplify_(dvecdt(y1, [q; p], [C*p; v]));
dy2dt = simplify_(dvecdt(y2, [q; p], [C*p; v]));

% Second derivative for outputs
d2y1dt2 = dvecdt(dy1dt, [q; p], [C*p; [v(1); z_1]]);
d2y2dt2 = dvecdt(dy2dt, [q; p], [C*p; [v(1); z_1]]);

dydt = [dy1dt; dy2dt];
d2ydt2 = [d2y1dt2; d2y2dt2];

pos = subs([x_sym(1:2); dydt; d2ydt2], [q; p; z_1], x_sym);
ref_ = [y_ref; yp_ref; ypp_ref];

pos_val = subs(pos, x_ref_sym, [sol(:, 1); ref_func(0)]);
ref_val = subs(ref_, x_ref_sym, [sol(:, 1); ref_func(0)]);

errors = pos_val - ref_val;
e0 = subs(errors, ...
          [x_ref_sym; symbs.'], ...
          [sol(:, 1); ref_func(0); model_params.']);
e0 = [e0(1); e0(3); e0(5); e0(2); e0(4); e0(6)];

A1 = ctrb_canon(poles_{1});
A2 = ctrb_canon(poles_{2});

e_n = canon_Rn(length(poles_{1}), 1)';
C = blkdiag(e_n, e_n);

R_syms = sys.descrip.syms(2);
R_val = sys.descrip.model_params(2);
syms t_;

errors_t = [];
for i = 1:length(t)
    eAt = expm(blkdiag(A1, A2)*t_);
    CAte0 = subs(C*eAt*e0, [t_, R_syms], [t(i), R_val]);
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

% ----------- Input plot ---------------
plot_info_e.titles = repeat_str('', 2);
plot_info_e.ylabels = {'$\tau_{\theta}$', '$\tau_{\phi}$'};
plot_info_e.xlabels = repeat_str('$t$ [s]', 2);
plot_info_e.grid_size = [2, 1];

input_torque_ = input_torque(1:length(t), :);

hfigs_u = my_plot(t, input_torque_, plot_info_e);
% --------------------------------------

% ----------- Speed plot ---------------
C = sys.kin.C;
qp_x = subs(C*p, [q; p; z_1], x_sym);

symbs = sys.descrip.syms;
model_params = sys.descrip.model_params;

qp_t = [];
for i = 1:length(t)
    t_i = t(i);
    qp_i = subs(qp_x, [x_sym; symbs.'], [sol(:, i); model_params.'])';
    qp_t = [qp_t; qp_i];
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

saveas(hfig_references, '../imgs/references', 'epsc');
saveas(hfig_states, '../imgs/states', 'epsc');
saveas(hfig_statesxy, '../imgs/statesxy', 'epsc');
saveas(hfig_errors, '../imgs/errors', 'epsc');
saveas(hfig_qpt, '../imgs/dstates', 'epsc');
saveas(hfigs_u, '../imgs/input', 'epsc');

