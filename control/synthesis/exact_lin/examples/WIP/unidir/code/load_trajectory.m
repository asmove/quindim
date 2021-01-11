syms t real;

% [rad/s]
w = 1;

expr_syms = {[cos(w*t); -w*sin(w*t); -(w^2)*cos(w*t); ...
              sin(w*t); w*cos(w*t); -(w^2)*sin(w*t); ...
              w*t; w; 0]};
vars = {t};

Outputs = {{'trajs'}};

paths = {[model_name, '/trajectory_function']};

fun_names = {'TrajectoryGenerator'};
script_struct.expr_syms = expr_syms;
script_struct.vars = vars;
script_struct.Outputs = Outputs;
script_struct.paths = paths;
script_struct.fun_names = fun_names;

model_name = 'tracking_model2';
genscripts(sys, model_name, script_struct);
