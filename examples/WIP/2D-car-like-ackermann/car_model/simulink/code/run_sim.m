% Final time
L = sys.descrip.model_params(end-2);
w = sys.descrip.model_params(end-3);

% Main matrices
sys.kin.C = subs(sys.kin.C, delta_o, delta_o_expr);
sys.kin.A = subs(sys.kin.A, delta_o, delta_o_expr);
sys.dyn.h = subs(sys.dyn.h, delta_o, delta_o_expr);
sys.dyn.M = subs(sys.dyn.M, delta_o, delta_o_expr);

% States saturation
EPS_ = 1e-5;

% Degrees [deg]
MAX_DELTA = 45;
MAX_DELTA = deg2rad(MAX_DELTA);

m = length(sys.kin.p{end});
p_val = 5;

% Initial conditions
delta_i_num = 0;

qs = [0; 0.5; 0; delta_i_num; delta_o_expr; 0; 0; 0; 0];
ps = [-0.1; 25];

symbs = [sys.descrip.syms.'; delta_i];
vals = [sys.descrip.model_params.'; delta_i_num];

qs0 = double(subs(qs, symbs, vals));
ps0 = double(subs(ps, symbs, vals));
x0 = double(subs([qs0; ps0], symbs, vals));

IS_IN = 0;
IS_OUT = 1;

x0_on_boundary = (x0(4) >= MAX_DELTA - EPS_)||(x0(4) <= -MAX_DELTA + EPS_);
curr_state0 = terop(x0_on_boundary, IS_IN, IS_OUT);

model_name = 'car_model';

tf = 20;
dt = 0.01;

% Model loading
abs_tol = '1e-6';
rel_tol = '1e-6';
         
% Function loader
simcode_gen = @(sys, model_name) load_simulink_model(model, paths, ...
                                                     fun_names, Outputs, ...
                                                     expr_syms, vars);
simOut = sim_block_diagram(sys, model_name, simcode_gen, ...
                           abs_tol, rel_tol);

set_param(model, 'SimulationMode', simMode);

q = simOut.coordinates.signals.values;
p = simOut.speeds.signals.values;
sol = [q, p];
tspan = simOut.tout;


