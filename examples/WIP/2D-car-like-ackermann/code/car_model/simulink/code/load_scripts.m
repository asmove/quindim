
paths = {'car_model/Vehicle/Steering_model/Auxiliary_matrices/C_p', ...
         'car_model/Vehicle/Steering_model/Auxiliary_matrices/Q', ...
<<<<<<< HEAD:examples/WIP/2D-car-like-ackermann/code/car_model/simulink/code/load_scripts.m
         'car_model/Vehicle/Steering_model/Auxiliary_matrices/A_matrix', ...
         'car_model/Vehicle/Steering_model/Auxiliary_matrices/C_matrix', ...
         'car_model/Vehicle/Steering_model/Auxiliary_matrices/dA_matrix', ...
         'car_model/Vehicle/Steering_model/Mass_block/mass_tensor', ...
         'car_model/Vehicle/Steering_model/Efforts/Constrained_efforts'};

syms M Q inv_M sqrt_M M_12 A_matrix Ap_matrix C_matrix Cp_matrix;

vars = {{[q; p]}, {[q; p], qp, u}, {[q; p]}, ...
        {[q; p]}, {[q; p]}, {[q; p]}, ...
        {[q; p], u}, {[q; p], u}};

Q = sys.dyn.U*sys.descrip.u - sys.dyn.nu - sys.dyn.g - sys.dyn.f_b - sys.dyn.f_k;

Z = sys.dyn.Z;
u = sys.descrip.u;
h = sys.dyn.h;
C = sys.kin.C;
A = sys.kin.A;
dA = dmatdt(A, q, C*p);
dC = dmatdt(C, q, C*p);
M = sys.dyn.M;

expr_syms = {C*p; Q; A; C; dA; M; Z*u - h};

for expr_sym = expr_syms
    if(isempty(expr_sym))
        expr_sym = 0;
    end
end

Outputs = {{'qp'}, {'Q'}, {'A'}, {'C'}, {'dA'}, {'M_matrix'}, {'fs'}};

fun_names = {'KinematicVector', ...
             'EffortVector', ...
             'ConstraintMatrix', ...
             'KinematicMatrix', ...
             'dConstraintMatrix', ...
             'Mass_matrix', ...
             'ConstrainedEffort'};

symbs = sys.descrip.syms;
vals = sys.descrip.model_params;

% Read buffer
nchar = 100000;

model = 'car_model';

open_system(model);

sf = Simulink.Root;

for i = 1:length(paths)
    block = sf.find('Path', paths{i}, '-isa','Stateflow.EMChart');
    
    expr_sym = expr_syms{i};
    output = Outputs{i};
    vars_i = vars{i};
    fun_name = fun_names{i};
    
    expr_sym = subs(expr_sym, symbs, vals);
    matlabFunction(expr_sym, 'File', fun_name, 'Vars', vars_i, 'Outputs', output);
    
    fname = [fun_name, '.m'];
    file_handle = fopen(fname, 'r');
    
    f_call = fgets(file_handle, nchar);
    script_body = f_call;
    
    tline = fgets(file_handle, nchar);
    
    while(strcmp(tline(1), '%'))
        tline = fgets(file_handle, nchar);
    end
    
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

=======
         'car_model/Vehicle/Steering_model/Auxiliary_matrices/C_1delta', ...
         'car_model/Vehicle/Steering_model/Auxiliary_matrices/dC_1delta', ...
         'car_model/Vehicle/Steering_model/Auxiliary_matrices/dA_1delta', ...
         'car_model/Vehicle/Steering_model/Friction_model', ...
         'car_model/Vehicle/Steering_model/Efforts', ...
         'car_model/Vehicle/Steering_model/H/Efforts'};
     
     
block = sf.find('Path', ,'-isa','Stateflow.EMChart');
>>>>>>> parent of c111475... Saturated car model:examples/2D-car-like-ackermann/code/car_model/simulink/code/load_scripts.m
