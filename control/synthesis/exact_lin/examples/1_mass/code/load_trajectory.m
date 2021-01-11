syms t real;

% [rad/s]
w = 10;

expr_syms = {[sin(w*t); w*cos(w*t); -(w^2)*sin(w*t)]};
vars = {t};

Outputs = {{'trajs'}};

paths = {[model_name, '/trajectory_function']};

fun_names = {'TrajectoryGenerator'};
script_struct.expr_syms = expr_syms;
script_struct.vars = vars;
script_struct.Outputs = Outputs;
script_struct.paths = paths;
script_struct.fun_names = fun_names;

model_name = 'tracking_model';

genscripts(sys, model_name, script_struct);
