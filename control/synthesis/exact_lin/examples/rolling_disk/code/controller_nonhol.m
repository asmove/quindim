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

L_2_f_h1 = simplify_(d2y1dt2 - L_G_L_f_h1*v);
L_2_f_h2 = simplify_(d2y2dt2 - L_G_L_f_h2*v);

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
V = [0 1; 1, 0];
qpz = [q; p; z_1];

% Plant
plant = subs([C*p; V*u_new; w_1], qpz, x_sym);
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

invA2 = simplify_(inv(A2));
w = vpa(invA2*(-L_3_f_h-K2*epp-K1*ep-K0*e+yppp_ref));
w = subs(w, symbs, model_params);

u = sym('u', [2, 1]);
up = sym('up', [2, 1]);

xp = [subs(C*p, [q; p], x_sym(1:6)); u(2); x_sym(end); u(1)];
out = dvecdt(L_3_f_h + A2*u, [x_sym; u], [xp; up]);
out = subs(out, up, [0; 0]);
out = collect(out, u);

