H = simplify_(sys.dyn.H);
H_sym = sym('H_', size(sys.dyn.H));

n = length(H);

H_sym_flatten = reshape(H_sym, [n^2, 1]);
H_flatten = reshape(H, [n^2, 1]);

invH_sym = inv(H_sym);
invH = subs(invH_sym, H_sym_flatten, H_flatten);

u = sys.descrip.u;
h = simplify_(sys.dyn.h);
Z = simplify_(sys.dyn.Z);
C = simplify_(sys.kin.C);

n_u = length(u);
n_H = length(H);

q = sys.kin.q;
p = sys.kin.p{end};

y = q(1:3);
x = [q; p];

plant = [C*p; invH*(-h + Z*u)];

f = subs(plant, u, zeros(n_u, 1));
G = equationsToMatrix(plant, u);

reldeg_struct = nreldegs(f, G, y, x);

H_sym = sym('H_', [n_H, n_H]);
invH_sym = sym('invH_', [n_H, n_H]);
inv_Hsym = inv(H_sym);

H_sym_flatten = reshape(H_sym, [n_H^2, 1]);
H_flatten = reshape(H, [n_H^2, 1]);
invH_sym_flatten = reshape(invH_sym, [n_H^2, 1]);
inv_Hsym_flatten = reshape(inv_Hsym, [n_H^2, 1]);

invH_val_flatten = subs(inv_Hsym_flatten, H_sym_flatten, H_flatten);

c_val = sys.kin.C(1:3, 2);
z_val = sys.dyn.Z(2, 2:3);

jac_y = jacobian(y, q);
c_sym = sym('c_', [3, 1]);
z_sym = sym('z_', [1, 2]);
Z_sym = [1, 0, 0; 0 z_sym];
jac_y_C = [zeros(3, 1), c_sym];

Delta_sym = jac_y_C*invH_sym*Z_sym;

symbs = [z_sym.'; c_sym; invH_sym_flatten];
vals = [z_val.'; c_val; invH_val];

Delta_val = subs(Delta_sym, symbs, vals);
[V, D] = eig(Delta_sym);

E = [0 0 1; 0 1 0; 1 0 0];
V = c(3)*invH_sym(2, 1)*V;
invV = inv(V);

S_sym = V*E;
S_val = subs(S_sym, symbs, vals);

phis = reldeg_struct.phis;

A = Delta_val*S_val;

a = A(:, 1);

z_1 = sym('z_', 1);
w = sym('w_', [3, 1]);

phis = reldeg_struct.phis;
y_delta_2 = phis + a*z_1;
phis = [phis; y_delta_2];


y_pps = sym('ypp_');

u_new = [z_1; w(2:3)];

vals = [q; p; z_1];
dvals = [C*p; invH_sym*(-h + Z*S_sym*u_new); w(1)];
y_delta_3 = dvecdt(y_delta_2, vals, dvals);

Delta_tilde = equationsToMatrix(y_delta_3, w);
phi_tilde = subs(y_delta_3, w, zeros(size(w)));

I_n = eye(length(Delta_tilde));
Delta_sym = sym('D_', size(Delta_tilde));
inv_Delta_sym = inv(Delta_sym);

Delta_sym_flatten = reshape(Delta_sym, [n_D^2, 1]);
Delta_flatten = reshape(Delta_tilde, [n_D^2, 1]);

Delta_inv = subs(inv_Delta_sym, Delta_sym_flatten, Delta_flatten);

u = Delta_inv*(-A_delta*z_tilde + B_delta*v - phis + y_pps);

run('load_poles.m');

[A, B, A_Delta, B_Delta] = lindyn(poles_);

Delta_inv*(-A_delta*z_tilde + B_delta*v - phis + y_pps);

% A = double(out.As);
% B = double(out.Bs);
% z_tilde = out.z_tilde;
% 
% K = place(A, B, poles_v);
% v_expr = vpa(-K*z_tilde);
% 
% q = sys.kin.q;
% p = sys.kin.p{end};
% 
% u_expr = out.u;
% v_sym = out.v;
% refs = out.y_ref_sym;
% x_sym = [q; p];
% 
% % Control function u
% expr_syms = {{u_expr}};
% vars = {{x_sym, v_sym, refs}};
% 
% model_name = 'tracking_model2';
% 
% Outputs = {{'u'}};
% 
% paths = {[model_name, '/control_function_u']};
% 
% fun_names = {'ControlFunction'};
% script_struct.expr_syms = expr_syms;
% script_struct.vars = vars;
% script_struct.Outputs = Outputs;
% script_struct.paths = paths;
% script_struct.fun_names = fun_names;
% 
% genscripts(sys, model_name, script_struct);
% 
% % Control function v
% expr_syms = {{v_expr}};
% vars = {{x_sym, refs}};
% 
% Outputs = {{'v'}};
% 
% paths = {[model_name, '/control_function_v']};
% 
% fun_names = {'ControlFunction'};
% script_struct.expr_syms = expr_syms;
% script_struct.vars = vars;
% script_struct.Outputs = Outputs;
% script_struct.paths = paths;
% script_struct.fun_names = fun_names;
% 
% genscripts(sys, model_name, script_struct);
