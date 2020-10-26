% ------------ Kinematic Block ------------

% Front angles
delta_i_num = 0;

% Holonomic expression
delta_o_expr = atan(L*tan(delta_i)/(L + w*tan(delta_i)));

m = length(sys.kin.p{end});
p_val = 5;
qs = [0; 0; 0; delta_i_num; delta_o_expr; 0; 0; 0; 0];
ps = [0; 4; 2];

model_params = sys.descrip.model_params;

syms_x0 = [sys.descrip.syms.'; delta_i];
vals_x0 = [model_params.'; delta_i_num];

x0 = double(subs([qs; ps], syms_x0, vals_x0));

syms t;

q_p = [sys.kin.q; sys.kin.p{end}];
qp = sys.kin.C*sys.kin.p{end};

symbs = sys.descrip.syms;
qp = subs(qp, symbs, model_params);

matlabFunction(qp, 'File', 'KinematicVector', 'Vars', {t, q_p}, 'Outputs', {'qp'});

% ----------------------------------------

% ------------ Kinematic Block ------------

% Symbolic variables
syms kappa alpha

A11 = simplify_(equationsToMatrix(v_i, sys.kin.qp));
vi_p = A11*sys.kin.C*sys.kin.p{end};

v_1 = -[kappa; kappa*tan(alpha)]*vi_p;

% residual_speeds = [0; 0; v_1; v_2];
residual_speeds = [0; 0; v_1];
