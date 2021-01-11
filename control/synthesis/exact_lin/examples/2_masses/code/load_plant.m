q = sys.kin.q;
qp = sys.kin.qp;
p = sys.kin.p{end};
u = sys.descrip.u;

Z = sys.dyn.Z;
u = sys.descrip.u;
h = sys.dyn.h;
C = sys.kin.C;
A = sys.kin.A;
dA = dmatdt(A, q, C*p);
dC = dmatdt(C, q, C*p);
M = sys.dyn.M;

if(elem_isnull(sys.descrip.Fq))
    Q = - sys.dyn.nu - sys.dyn.g - sys.dyn.f_b - sys.dyn.f_k; 
    expr_syms = {C*p; C; M; - h};
    vars = {{[q; p]}, {[q; p]}, {[q; p]}, {[q; p]}};
else
    Q = sys.dyn.U*sys.descrip.u - sys.dyn.nu - sys.dyn.g - sys.dyn.f_b - sys.dyn.f_k; 
    expr_syms = {C*p; C; M; Z*u - h};

    vars = {{[q; p]}, {[q; p]}, {[q; p]}, {[q; p], u}};
end

Outputs = {{'qp'}, {'C'}, {'M_matrix'}, {'fs'}};
    
paths = {[model_name, '/Plant/Dynamic system/Auxiliary_matrices/C_p'], ...
         [model_name, '/Plant/Dynamic system/Auxiliary_matrices/C_matrix'], ...
         [model_name, '/Plant/Dynamic system/Mass_block/mass_tensor'], ...
         [model_name, '/Plant/Dynamic system/Efforts/Constrained_efforts']};

fun_names = {'KinematicVector', 'ConstraintMatrix', 'Mass_matrix', 'ConstrainedEffort'};

script_struct.Q = Q;
script_struct.expr_syms = expr_syms;
script_struct.vars = vars;
script_struct.Outputs = Outputs;
script_struct.paths = paths;
script_struct.fun_names = fun_names;

model_name = 'tracking_model';

genscripts(sys, model_name, script_struct);
