q = sys.kin.q;
p = sys.kin.p{end};

% Output and reference
y = sys.kin.q(1);

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

y = sys.kin.q(1);
x = [sys.kin.q; ...
     sys.kin.p];

out = exact_lin(f, G, y, x);

u_expr = my_subs(out.u, sys.descrip.syms, sys.descrip.model_params);

expr_syms = {u_expr};
vars = {[q; p]};

yp = sys.kin.qp(1);
ypp = sys.kin.qpp(1);

refs = out.y_ref_sym;
y_ref = refs(1);
yp_ref = refs(2);

e = y - y_ref;
ep = yp - yp_ref;

A = double(out.As);
B = double(out.Bs);

poles_ = [-9, -10];
K = place(A, B, poles_);

v_ = -K*[e; ep];
u_expr = my_subs(u_expr, out.v, v_);
u_expr = my_subs(u_expr, sys.kin.qp, sys.kin.C*sys.kin.p{end}); 

expr_syms = {{u_expr}};
vars = {{[q; p], refs}};

Outputs = {{'u'}};

paths = {[model_name, '/control_function']};

fun_names = {'ControlFunction'};
script_struct.expr_syms = expr_syms;
script_struct.vars = vars;
script_struct.Outputs = Outputs;
script_struct.paths = paths;
script_struct.fun_names = fun_names;

model_name = 'tracking_model';
genscripts(sys, model_name, script_struct);
