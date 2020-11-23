% Paths on the simulink
paths = {'Vehicle/Steering_model/Auxiliary_matrices/C_p', ...
         'Vehicle/Steering_model/Auxiliary_matrices/Q', ...
         'Vehicle/Steering_model/Auxiliary_matrices/A_matrix', ...
         'Vehicle/Steering_model/Auxiliary_matrices/C_matrix', ...
         'Vehicle/Steering_model/Auxiliary_matrices/dA_matrix', ...
         'Vehicle/Steering_model/Mass_block/mass_tensor', ...
         'Vehicle/Steering_model/Efforts/Constrained_efforts'};

% Outputs to calculate
Outputs = {{'qp'}, {'Q'}, {'A'}, {'C'}, {'dA'}, {'M_matrix'}, {'fs'}};

% Symbolic varisbles
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

if(isempty(A))
    A = 0;
end

if(isempty(dA))
    dA = 0;
end

Q = sys.dyn.U*sys.descrip.u - sys.dyn.nu - sys.dyn.g - sys.dyn.f_b - sys.dyn.f_k;

% Symbolic variables convenientlu grouped
vars = {{[q; p]}, {[q; p], qp, u}, {[q; p]}, ...
        {[q; p]}, {[q; p]}, {[q; p]}, ...
        {[q; p], u}, {[q; p], u}};


% Symbolic expressions
expr_syms = {C*p; Q; A; C; dA; M; Z*u - h};

for i = 1:length(expr_syms)
    expr_syms{i} = subs(expr_syms{i}, sys.descrip.syms, sys.descrip.model_params);
end

% Function names
fun_names = {'KinematicVector', 'EffortVector', 'ConstraintMatrix', ...
             'KinematicMatrix', 'dConstraintMatrix', 'Mass_matrix', ...
             'ConstrainedEffort'};

% Function loader
load_simulink_model('car_model', paths, fun_names, Outputs, expr_syms, vars);
