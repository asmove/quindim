clear all
close all
clc

run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');

% Plant 
f = sys.dyn.f;
G = sys.dyn.G;

% Output and reference
y = sys.kin.q(1:2);

% States of the system
states = sys.dyn.states;

% States and velocities od the system
q = sys.kin.q;
qp = sys.kin.qp;
p = sys.kin.p{end};

% Coupling matrix
C = sys.kin.C;
Cp = sys.kin.Cp;

% Dynamic matrices
H = sys.dyn.H;
h = sys.dyn.h;
Z = sys.dyn.Z;

% Input
u = sys.descrip.u;
v = sym('v', size(u));
u_ = inv(Z)*(H*v + h);

% Output equations
y1 = y(1);
y2 = y(2);

% First derivative for outputs
dy1dt = dvecdt(y1, [q; p], [C*p; v]);
dy2dt = dvecdt(y2, [q; p], [C*p; v]);

L_G_L_f_h1 = equationsToMatrix(dy1dt, v);
L_G_L_f_h2 = equationsToMatrix(dy2dt, v);

L_f_h1 = simplify_(dy1dt - L_G_L_f_h1*v);
L_f_h2 = simplify_(dy2dt - L_G_L_f_h2*v);

% Second derivative for outputs
d2y1dt2 = dvecdt(dy1dt, [q; p], [C*p; v]);
d2y2dt2 = dvecdt(dy2dt, [q; p], [C*p; v]);

L_G_L_f_2_h1 = equationsToMatrix(d2y1dt2, v);
L_G_L_f_2_h2 = equationsToMatrix(d2y2dt2, v);

L_f_h1 = simplify_(d2y1dt2 - L_G_L_f_h1*v);
L_f_h2 = simplify_(d2y2dt2 - L_G_L_f_h2*v);

A1 = [L_G_L_f_2_h1; L_G_L_f_2_h2];

x_orig = [q; p; v(2)];
x_sym = sym('x_', [7, 1]);

% Null, first, second derivatives of:

% y1
y1 = subs(y1, x_orig, x_sym);
dy1dt = subs(dy1dt, x_orig, x_sym);
d2y1dt2 = subs(d2y1dt2, x_orig, x_sym);

% y2
y2 = subs(y2, x_orig, x_sym);
dy2dt = subs(dy2dt, x_orig, x_sym);
d2y2dt2 = subs(d2y2dt2, x_orig, x_sym);

dydt = [dy1dt; dy2dt];
d2ydt2 = [d2y1dt2; d2y2dt2];

z_transf = [y1; dy1dt; d2y1dt2; y2; dy2dt; d2y2dt2; x_sym(4)];
z_sym = sym('z_', [7, 1]);

R = sys.descrip.syms(2);
symbs = sys.descrip.syms;
model_params = sys.descrip.model_params;

w = sym('w', [2, 1]);

x_to_z = [x_sym(1); ...
          R*x_sym(6)*cos(x_sym(3)); ...
          R*(x_sym(7)*cos(x_sym(3)) - x_sym(5)*x_sym(6)*sin(x_sym(3))); ...
          x_sym(2); ...
          R*x_sym(6)*sin(x_sym(3)); ...
          R*(x_sym(7)*sin(x_sym(3)) + x_sym(5)*x_sym(6)*cos(x_sym(3))); ...
          x_sym(4)];

z_to_x = [z_sym(1); ...
          z_sym(4); ...
          atan2(z_sym(5), z_sym(2)); ...
          z_sym(7); ...
          (z_sym(6)*z_sym(2) - z_sym(3)*z_sym(5))/(z_sym(2)^2 + z_sym(5)^2); ...
          sqrt(z_sym(2)^2 + z_sym(5)^2)/R; ...
          (z_sym(3)*z_sym(2) + ...
           z_sym(6)*z_sym(5))/(R*sqrt(z_sym(2)^2 + z_sym(5)^2))];

x2z_fun = @(x) subs(x_to_z, x_sym, x);
z2x_fun = @(z) subs(z_to_x, z_sym, z);

% System analysis
x_params = ones(length(x_sym), 1);
model_params = sys.descrip.model_params;
z1 = double(subs(x_to_z, [x_sym; symbs.'], [x_params; model_params.']));
x1 = double(subs(z_to_x, [z_sym; symbs.'], [z1; model_params.']));

jac_xz = jacobian(x_to_z, x_sym);
det_xz = simplify_(det(jac_xz));

% New input
w_1 = sym('w_1');
w_2 = sym('w_2');
z_1 = sym('z_1');

w_syms = [w_1; w_2];

u_new = [z_1; w_2];
qpz = [q; p; z_1];

% Plant
plant = subs([C*p; u_new; w_1], qpz, x_sym);
zp = simplify_(dvecdt(x_to_z, x_sym, plant));
zp = simplify_(subs(zp, x_sym, z_to_x));

G_x = equationsToMatrix(plant, [w_1; w_2]);
f_x = simplify_(plant - G_x*[w_1; w_2]);

% Old input
w_s = [z_1; w_2];

% Third derivative for outputs
d3y1dt3 = simplify_(dvecdt(d2y1dt2, x_sym, plant));
d3y2dt3 = simplify_(dvecdt(d2y2dt2, x_sym, plant));

% Lie derivative terms
% ---------------------------------------------------------
% First derivative
L_G_h1 = equationsToMatrix(dy1dt, w_syms);
L_G_h2 = equationsToMatrix(dy2dt, w_syms);

L_f_h1 = simplify_(dy1dt - L_G_h1*w_syms);
L_f_h2 = simplify_(dy2dt - L_G_h2*w_syms);

% ---------------------------------------------------------
% Second derivative
L_G_L_f_h1 = equationsToMatrix(d2y1dt2, w_syms);
L_G_L_f_h2 = equationsToMatrix(d2y2dt2, w_syms);

L_2_f_h1 = simplify_(d2y1dt2 - L_G_L_f_h1*w_syms);
L_2_f_h2 = simplify_(d2y2dt2 - L_G_L_f_h2*w_syms);

% ---------------------------------------------------------
% Third derivative
L_G_L_2_f_h1 = equationsToMatrix(d3y1dt3, w_syms);
L_G_L_2_f_h2 = equationsToMatrix(d3y2dt3, w_syms);

L_3_f_h1 = simplify_(d3y1dt3 - L_G_L_2_f_h1*w_syms);
L_3_f_h2 = simplify_(d3y2dt3 - L_G_L_2_f_h2*w_syms);

A2 = [L_G_L_2_f_h1; L_G_L_2_f_h2];

v = sym('v', [2, 1]);

syms xppp yppp;

y = sys.kin.q(1:2);
yp = sys.kin.qp(1:2);
ypp = sys.kin.qpp(1:2);
yppp = [xppp; yppp];

y_ref = add_symsuffix(y, '_ref');
yp_ref = add_symsuffix(yp, '_ref');
ypp_ref = add_symsuffix(ypp, '_ref');
yppp_ref = add_symsuffix(yppp, '_ref');

ref_syms = [y_ref; yp_ref; ypp_ref; yppp_ref];

% Error and its derivatives
e = x_sym(1:2) - y_ref;
ep = dydt - yp_ref;
epp = d2ydt2 - ypp_ref;

roots_1 = [-5, -5, -5];
coeffs_1 = poly(roots_1);
coeffs_1 = coeffs_1(2:end);

roots_2 = [-5, -5, -5];
coeffs_2 = poly(roots_2);
coeffs_2 = coeffs_2(2:end);

coeffs_K0 = [coeffs_1(3); coeffs_2(3)];
coeffs_K1 = [coeffs_1(2); coeffs_2(2)];
coeffs_K2 = [coeffs_1(1); coeffs_2(1)];

K0 = diag(coeffs_K0);
K1 = diag(coeffs_K1);
K2 = diag(coeffs_K2);

L_3_f_h = simplify_([L_3_f_h1; L_3_f_h2]);

m = length(A2);

lambda = 1;
invA2 = simplify_(inv(A2));
pinvA2 = A2.'*inv(A2*A2.' + lambda*eye(m));
w = vpa(invA2*(-L_3_f_h-K2*epp-K1*ep-K0*e+yppp_ref));
w = subs(w, symbs, model_params);
V = [0, 1; 1, 0];

% Ellipsoid trajectory
a = 2;
b = 1;
omega = 1;

ref_func = @(t) [a*cos(omega*t); b*sin(omega*t); ...
                 -a*omega*sin(omega*t); b*omega*cos(omega*t); ...
                 -a*omega^2*cos(omega*t); -b*omega^2*sin(omega*t); ...
                 a*omega^3*sin(omega*t); -b*omega^3*cos(omega*t)];

x_ref_sym = [x_sym; ref_syms];

input_func = @(t, q_p) vpa(subs(w, x_ref_sym, [q_p; ref_func(t)]));
sim_fun = @(t, q_p) plant_fun(t, q_p, sys, input_func, V);

symbs = [w_syms; x_sym; symbs.'];

x0 = [1; 0; 0; 0; 1; 0; 0];
tf = pi/2;
dt = 0.01;

% Time vector
t = 0:dt:tf;

% Mass matrix
sol = my_ode45(sim_fun, t, x0);
sol = sol';

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

% axis square;

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

syms t_;
errors_t = [];
for t_i = t
    CAt = subs(C*expm(blkdiag(A1, A2)*t_), t_, t_i);
    errors_t = [errors_t; (CAt*e0)'];
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
    thetap_d = atan2(xp_yp_d(2), xp_yp_d(1));
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

% ----------- Reference plot -----------

symbs = sys.descrip.syms;
model_params = sys.descrip.model_params;
constraints = subs(sys.descrip.unhol_constraints, ...
                   [q; p; z_1; symbs.'], ...
                   [x_sym; model_params.']);
               
constraints_t = [];
for  i = 1:length(t)
    numvars = [sol(i, :)'; qp_ref(i, :)'];    
    constraints_i = subs(constraints, [x_sym; qp], numvars);
    constraints_t = [constraints_t; constraints_i];
end

plot_info_consts.titles = {''};
latex_orig = ['$', latex(constraints), '$'];
plot_info_consts.ylabels = {str2latex(latex_orig, ...
                                      sys.descrip.latex_origs, ...
                                      sys.descrip.latex_text)};
plot_info_consts.xlabels = {'$t$ [s]'};
plot_info_consts.grid_size = [1, 1];

hfig_consts = my_plot(t, constraints_t, plot_info_consts);

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
saveas(hfig_consts, ['../imgs/constraints', ...
                     num2str(a), ...
                     num2str(b)], 'epsc');

