H = simplify_(sys.dyn.H);
invH = inv(H);

u = sys.descrip.u;
h = simplify_(sys.dyn.h);
Z = simplify_(sys.dyn.Z);
C = simplify_(sys.kin.C);

q = sys.kin.q;
p = simplify_(sys.kin.p{end});

plant = [C*p; invH*(-h + Z*u)];

G = simplify_(equationsToMatrix(plant, u));
f = simplify_(plant - G*u);

y = sys.kin.q(1:3);
x = [sys.kin.q; sys.kin.p];

out = exact_lin(f, G, y, x);

pole_c = -10;
delta = sum(out.deltas);
poles_v = pole_c*rand([delta, 1]);

A = double(out.As);
B = double(out.Bs);
z_tilde = out.z_tilde;

K = place(A, B, poles_v);
v_expr = vpa(-K*z_tilde);

q = sys.kin.q;
p = sys.kin.p{end};

u_expr = out.u;
v_sym = out.v;
refs = out.y_ref_sym;
x_sym = [q; p];

% Control function u
expr_syms = {{u_expr}};
vars = {{x_sym, v_sym, refs}};

model_name = 'tracking_model2';

Outputs = {{'u'}};

paths = {[model_name, '/control_function_u']};

fun_names = {'ControlFunction'};
script_struct.expr_syms = expr_syms;
script_struct.vars = vars;
script_struct.Outputs = Outputs;
script_struct.paths = paths;
script_struct.fun_names = fun_names;

genscripts(sys, model_name, script_struct);

% Control function v
expr_syms = {{v_expr}};
vars = {{x_sym, refs}};

Outputs = {{'v'}};

paths = {[model_name, '/control_function_v']};

fun_names = {'ControlFunction'};
script_struct.expr_syms = expr_syms;
script_struct.vars = vars;
script_struct.Outputs = Outputs;
script_struct.paths = paths;
script_struct.fun_names = fun_names;

genscripts(sys, model_name, script_struct);
