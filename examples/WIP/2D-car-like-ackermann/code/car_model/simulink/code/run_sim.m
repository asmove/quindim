% Final time
<<<<<<< HEAD:examples/WIP/2D-car-like-ackermann/code/car_model/simulink/code/run_sim.m

tf = 3;
dt = 0.01;

% Holonomic expression
delta_i = sys.kin.q(3);
delta_o = sys.kin.q(4);
delta_o_expr = atan(L*tan(delta_i)/(L + w*tan(delta_i)));

% Main matrices
sys.kin.C = subs(sys.kin.C, delta_o, delta_o_expr);
sys.kin.A = subs(sys.kin.A, delta_o, delta_o_expr);
sys.dyn.h = subs(sys.dyn.h, delta_o, delta_o_expr);
sys.dyn.M = subs(sys.dyn.M, delta_o, delta_o_expr);

% States saturation
EPS_ = 1e-5;
MAX_DELTA = 15;
MAX_DELTA = deg2rad(MAX_DELTA);

x0_on_boundary = (x0(4) >= MAX_DELTA - EPS_)||(x0(4) <= -MAX_DELTA + EPS_);
curr_state0 = terop(x0_on_boundary, IS_IN, IS_OUT);

% Time [s]
t = 0:dt:tf;

% Initial conditions
delta_i_num = 0;

m = length(sys.kin.p{end});
p_val = 5;

qs = [0; 0; pi/4; delta_i_num; delta_o_expr; 0; 0; 0; 0];
ps = [0; 0; 1; 1];

symbs = [sys.descrip.syms.'; delta_i];
vals = [sys.descrip.model_params.'; delta_i_num];

qs0 = double(subs(qs, symbs, vals));
ps0 = double(subs(ps, symbs, vals));
x0 = double(subs([qs0; ps0], symbs, vals));
=======
tf = 5;
>>>>>>> parent of c111475... Saturated car model:examples/2D-car-like-ackermann/code/car_model/simulink/code/run_sim.m

% Model loading
model = 'car_model';

load_system(model);

simMode = get_param(model, 'SimulationMode');
set_param(model, 'SimulationMode', 'normal');

cs = getActiveConfigSet(model);
mdl_cs = cs.copy;
<<<<<<< HEAD:examples/WIP/2D-car-like-ackermann/code/car_model/simulink/code/run_sim.m
set_param(mdl_cs, 'SolverType','Variable-step', ...
                  'SaveState','on','StateSaveName','xoutNew', ...
                  'SaveOutput','on','OutputSaveName','youtNew');
=======
set_param(mdl_cs,'AbsTol','1e-6',...
                 'SaveState','on','StateSaveName','xoutNew',...
                 'SaveOutput','on','OutputSaveName','youtNew');
>>>>>>> parent of c111475... Saturated car model:examples/2D-car-like-ackermann/code/car_model/simulink/code/run_sim.m

save_system();
              
t0 = tic();
simOut = sim(model, mdl_cs);
toc(t0);

set_param(model, 'SimulationMode', simMode);

