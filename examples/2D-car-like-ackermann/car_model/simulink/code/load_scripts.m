paths = {'car_model/Vehicle/Steering_model/Auxiliary_matrices/C_p', ...
         'car_model/Vehicle/Steering_model/Auxiliary_matrices/Q', ...
         'car_model/Vehicle/Steering_model/Auxiliary_matrices/A_matrix', ...
         'car_model/Vehicle/Steering_model/Auxiliary_matrices/C_matrix', ...
         'car_model/Vehicle/Steering_model/Auxiliary_matrices/dA_matrix', ...
         'car_model/Vehicle/Steering_model/Mass_block/mass_tensor', ...
         'car_model/Vehicle/Steering_model/Efforts/Constrained_efforts'};

Outputs = {{'qp'}, {'Q'}, {'A'}, {'C'}, {'dA'}, {'M_matrix'}, {'fs'}};

fun_names = {'KinematicVector', 'EffortVector', 'ConstraintMatrix', ...
             'KinematicMatrix', 'dConstraintMatrix', 'Mass_matrix', ...
             'ConstrainedEffort'};

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

Q = sys.dyn.U*sys.descrip.u - sys.dyn.nu - sys.dyn.g - sys.dyn.f_b - sys.dyn.f_k;

vars = {{[q; p]}, {[q; p], qp, u}, {[q; p]}, ...
        {[q; p]}, {[q; p]}, {[q; p]}, ...
        {[q; p], u}, {[q; p], u}};

expr_syms = {C*p; Q; A; C; dA; M; Z*u - h};

for expr_sym = expr_syms
    if(isempty(expr_sym))
        expr_sym = 0;
    end
end
    
n = length(paths);
         
% Holonomic expression
delta_i = sys.kin.q(4);
delta_o = sys.kin.q(5);
delta_o_expr = atan(L*tan(delta_i)/(L + w*tan(delta_i)));

% Main matrices
sys.kin.C = subs(sys.kin.C, delta_o, delta_o_expr);
sys.kin.A = subs(sys.kin.A, delta_o, delta_o_expr);
sys.dyn.h = subs(sys.dyn.h, delta_o, delta_o_expr);
sys.dyn.M = subs(sys.dyn.M, delta_o, delta_o_expr);

symbs = sys.descrip.syms;
model_params = sys.descrip.model_params;
delta_o_expr = subs(delta_o_expr, symbs, model_params);

symbs = [sys.descrip.syms, delta_o];
vals = [sys.descrip.model_params, delta_o_expr];

% Read buffer
nchar = 100000;

model = 'car_model';

open_system(model);

sf = Simulink.Root;

for i = 1:n
    block = sf.find('Path', paths{i}, '-isa','Stateflow.EMChart');
    
    % Properties of the file
    expr_sym = expr_syms{i};
    output = Outputs{i};
    vars_i = vars{i};
    fun_name = fun_names{i};
    
    expr_sym_subs = subs(expr_sym, symbs, vals);
    matlabFunction(expr_sym_subs, ...
                   'File', fun_name, ...
                   'Vars', vars_i, ...
                   'Outputs', output);
    
    fname = [fun_name, '.m'];
    file_handle = fopen(fname, 'r');
    
    % Title
    f_call = fgets(file_handle, nchar);
    script_body = f_call;
    
    tline = fgets(file_handle, nchar);
    
    while(strcmp(tline(1), '%'))
        tline = fgets(file_handle, nchar);
    end
    
    % Script body
    tline = fgets(file_handle, nchar);
    while(tline ~= -1)
        script_body = [script_body newline tline];
        tline = fgets(file_handle, nchar);
    end
    
    script_body = [script_body newline 'end'];
    
    fclose(file_handle);
    delete(fname);
    
    file_handle = fopen(fname, 'w');
    fprintf(file_handle, '%s', script_body);    
    fclose(file_handle);
    
    block.Script = script_body;
    delete(fname);
end

save_system(model);
close_system(model);
