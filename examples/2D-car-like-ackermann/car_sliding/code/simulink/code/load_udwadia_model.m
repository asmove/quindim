syms dkappa_i dkappa_o dkappa_r dkappa_l real;
syms dalpha_i dalpha_o dalpha_r dalpha_l real;

% Constraint matrices
hol_constraints = sys.descrip.hol_constraints{1};
dhol_constraints = dvecdt(hol_constraints, sys.kin.q, sys.kin.qp);
A_hol = equationsToMatrix(dhol_constraints, sys.kin.qp);

A_1delta = [A_hol; B*v_proj_vec];
n_A_1delta = numel(A_1delta);

isnonnull_A_1delta = elem_isnonnull(A_1delta);
A_sym = sym('A_', size(A_1delta));
A_sym = A_sym.*isnonnull_A_1delta;
C_sym = null(A_sym);

A_1delta_flatten = flatten(A_1delta);
A_sym = flatten(A_sym);

isnonnull_Aflatten = elem_isnonnull(A_1delta_flatten);

A_1delta_flatten = A_1delta_flatten.*isnonnull_Aflatten;

A_sym_vals = remove_zeros(A_sym);
A_1delta_vals = remove_zeros(A_1delta_flatten);

% Kinematic matrix
C_1delta = subs(C_sym, A_sym_vals, A_1delta_vals);
C_1 = simplify(sys.kin.C);
C_delta = C_1delta - C_1;

q = sys.kin.q;
p = sys.kin.p{end};
qp = C_1delta*p;

kappa_alpha = [kappa_i kappa_o kappa_r kappa_l, ...
               alpha_i alpha_o alpha_r alpha_l].';

dkappa_dalpha = [dkappa_i dkappa_o dkappa_r dkappa_l, ...
                 dalpha_i dalpha_o dalpha_r dalpha_l].';

vars = [q; kappa_alpha];
dvars = [qp; dkappa_dalpha];

dC_1delta = dmatdt(C_1delta, vars, dvars);

M = sys.dyn.M;
nu = sys.dyn.nu;

H = C_1delta.'*M*C_1delta;
h = C_1delta.'*(nu + M*dC_1delta*p);
Z = C_1delta.'*sys.dyn.U;
u = sys.descrip.u;

H_sym = sym('H_', size(H));
invH_sym = inv(H_sym);
invH = subs(invH_sym, flatten(H_sym), flatten(H));

symbs_vals = sys.descrip.syms;
model_params_vals = sys.descrip.model_params;

plant = [C_1delta*p; invH*(-h + Z*u)];
plant_subs = subs(plant, symbs_vals, model_params_vals);

% Symbolic variables for slipping model
syms t real;

kappa_i_sym = 0; 
kappa_o_sym = 0; 
kappa_r_sym = 0; 
kappa_l_sym = 0;
alpha_i_sym = 0; 
alpha_o_sym = 0; 
alpha_r_sym = 0; 
alpha_l_sym = 0;

dkappa_i_sym = diff(kappa_i_sym, t);
dkappa_o_sym = diff(kappa_o_sym, t); 
dkappa_r_sym = diff(kappa_r_sym, t); 
dkappa_l_sym = diff(kappa_l_sym, t);
dalpha_i_sym = diff(alpha_i_sym, t); 
dalpha_o_sym = diff(alpha_o_sym, t); 
dalpha_r_sym = diff(alpha_r_sym, t); 
dalpha_l_sym = diff(alpha_l_sym, t);

