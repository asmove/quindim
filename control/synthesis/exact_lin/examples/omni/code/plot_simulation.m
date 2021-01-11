close all

clear plot_info_q;
clear plot_info_p;
clear plot_info_traj;
clear plot_info_readings;

% Generalized coordinates
plot_info_q.titles = repeat_str('', 3);
plot_info_q.xlabels = repeat_str('$t$ [s]', 3);
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$'};
plot_info_q.grid_size = [1, 3];
plot_info_q.legends = {{'$x(t)$', '$x^{\star}(t)$'}, ...
                        {'$y(t)$', '$y^{\star}(t)$'}, ...
                        {'$\theta(t)$', '$\theta^{\star}(t)$'}};
plot_info_q.pos_multiplots = [1, 2, 3];
plot_info_q.markers = {{'-', '--'}, {'-', '--'}, {'-', '--'}};

time_y = tspan;
states_xyth = states(:, 1:3);

trajs = [traj(:, 1), traj(:, 4), traj(:, 7)];
dtrajs = [traj(:, 2), traj(:, 5), traj(:, 8)];
ddtrajs = [traj(:, 3), traj(:, 6), traj(:, 9)];

ys = {states_xyth, trajs};

[hfigs_xyth, axs] = my_plot(time_y, ys, plot_info_q);

axs{1}{1}.FontSize = 25;
axs{1}{2}.FontSize = 25;
axs{1}{3}.FontSize = 25;

axis(axs{1}{1}, 'square');
axis(axs{1}{2}, 'square');
axis(axs{1}{3}, 'square');

% Generalized coordinates
plot_info_q.titles = repeat_str('', 3);
plot_info_q.xlabels = repeat_str('$t$ [s]', 3);
plot_info_q.ylabels = {'$\theta_1$', '$\theta_2$', '$\theta_3$'};
plot_info_q.grid_size = [1, 3];

time_y = tspan;
states_phis = states(:, 4:6);
ys = states_phis;

[hfigs_states, axs] = my_plot(tspan, states(:, 4:6), plot_info_q);

axs{1}{1}.FontSize = 25;
axs{1}{2}.FontSize = 25;
axs{1}{3}.FontSize = 25;

axis(axs{1}{1}, 'square');
axis(axs{1}{2}, 'square');
axis(axs{1}{3}, 'square');

% Errors 
errors_sim = [];

for i = 1:length(traj)
    errors_i = states(i, 1:3) - trajs(i, 1:3);
    errors_sim = [errors_sim; errors_i];
end

q_sym = sys.kin.q;
p_sym = sys.kin.p{end};
sym_states = [q_sym; p_sym];
sym_refs = out.y_ref_sym;

zs = out.z_tilde;

symbs = [sym_states; sym_refs];
vals = [states(1, :)'; traj(1, :)'];
e0 = double(subs(zs, symbs, vals));

A1 = ctrb_canon(poles_v(1:2));
A2 = ctrb_canon(poles_v(3:4));
A3 = ctrb_canon(poles_v(5:6));

A = double(blkdiag(A1, A2, A3));

n_p = length(poles_{1});
e_n = canon_Rn(n_p, 1)';
C = double(blkdiag(e_n, e_n, e_n));

syms t_;
errors_t = [];

wb = my_waitbar('Trajectory calculation');
for i = 1:length(tspan)
    CAte0 = C*expm(A*tspan(i))*e0;
    errors_t = [errors_t; CAte0'];

    wb.update_waitbar(i, length(tspan));
end
wb.close_window();

plot_info_st.titles = repeat_str('', 3);
plot_info_st.xlabels = repeat_str('$t$ [s]', 3);
plot_info_st.ylabels = {'$e_x(t)$', '$e_y(t)$', '$e_{\theta}(t)$'};
plot_info_st.grid_size = [1, 3];
plot_info_st.legends = {{'$e_x^s(t)$', '$e_x^t(t)$'}, ...
                        {'$e_y^s(t)$', '$e_y^t(t)$'}, ...
                        {'$e_{\theta}^s(t)$', '$e_{\theta}^t(t)$'}};
plot_info_st.pos_multiplots = [1, 2, 3];
plot_info_st.markers = {{'-', '--'}, {'-', '--'}, {'-', '--'}};

errors_ = {errors_sim, errors_t};

[hfigs_errors, axs] = my_plot(tspan, errors_, plot_info_st);

axs{1}{1}.FontSize = 25;
axs{1}{2}.FontSize = 25;
axs{1}{3}.FontSize = 25;

axis(axs{1}{1}, 'square');
axis(axs{1}{2}, 'square');
axis(axs{1}{3}, 'square');

% Speeds plot
plot_info_p.titles = repeat_str('', 3);
plot_info_p.xlabels = repeat_str('$t$ [s]', 3);
plot_info_p.ylabels = {'$\dot x$', '$\dot y$', '$\dot{\theta}$'};
plot_info_p.grid_size = [1, 3];

[n_s, ~] = size(states);
[n_t, ~] = size(trajs);

n_min = min(n_s, n_t);

speed = states(:, 7:end);

[hfigs_speeds, axs] = my_plot(tspan, speed, plot_info_p);

axs{1}{1}.FontSize = 25;
axs{1}{2}.FontSize = 25;
axs{1}{3}.FontSize = 25;

axis(axs{1}{1}, 'square');
axis(axs{1}{2}, 'square');
axis(axs{1}{3}, 'square');

% Control plot
plot_info_u.titles = repeat_str('', 3);
plot_info_u.xlabels = repeat_str('$t$ [s]', 3);
plot_info_u.ylabels = {'$\tau_1$', '$\tau_2$', '$\tau_3$'};
plot_info_u.grid_size = [1, 3];

[hfigs_u, axs] = my_plot(tspan, u, plot_info_u);

axs{1}{1}.FontSize = 25;
axs{1}{2}.FontSize = 25;
axs{1}{3}.FontSize = 25;

axis(axs{1}{1}, 'square');
axis(axs{1}{2}, 'square');
axis(axs{1}{3}, 'square');

% x-y cartesian plot
plot_info_u.titles = {''};
plot_info_u.xlabels = {'x [m]'};
plot_info_u.ylabels = {'y [m]'};
plot_info_u.grid_size = [1, 1];
plot_info_st.legends = {{'$s(t)$', '$s^{\star}(t)$'}};
plot_info_st.pos_multiplots = 1;
plot_info_st.markers = {{'-', '--'}};

hfig_xy = my_figure();

plot(states(:, 1), states(:, 2));
hold on;
plot(trajs(:, 1), trajs(:, 2), '--');

xlabel('$x$ $[m]$', 'interpreter', 'latex');
ylabel('$y$ $[m]$', 'interpreter', 'latex');

axis(gca, 'square');
axis([-1.5 1.5 -1.5 1.5]);

axs = gca;

axs.FontSize = 25;
axs.FontSize = 25;
axs.FontSize = 25;

axis(axs, 'square');
axis(axs, 'square');
axis(axs, 'square');

saveas(hfigs_states, ['../imgs/states.eps'], 'epsc');
saveas(hfigs_xyth, ['../imgs/states_xy.eps'], 'epsc');
saveas(hfigs_speeds, ['../imgs/speeds.eps'], 'epsc');
saveas(hfigs_errors, ['../imgs/errors.eps'], 'epsc');
saveas(hfigs_u, ['../imgs/control.eps'], 'epsc');
