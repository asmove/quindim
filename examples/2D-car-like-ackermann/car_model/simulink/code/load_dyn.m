sys = calculate_jacobians(sys);
sys = update_jacobians(sys, sys.kin.C);

delta_sym = atan(tan(delta_i)/(1 + (varepsilon/2)*tan(delta_i)));

sys.kin.A = subs(sys.kin.A, delta, delta_sym);
sys.kin.C = subs(sys.kin.C, delta, delta_sym);

sys = dynamic_model(sys);

% Delta expression
sys.kin.A = subs(sys.kin.A, delta, delta_sym);
sys.kin.C = subs(sys.kin.C, delta, delta_sym);
sys.dyn.h = subs(sys.dyn.h, delta, delta_sym);
sys.dyn.Z = subs(sys.dyn.Z, delta, delta_sym);

% Holonomic expression
delta_i = sys.kin.q(4);
delta_o = sys.kin.q(5);
delta_o_expr = atan(L*tan(delta_i)/(L + w*tan(delta_i)));

symbs = [sys.descrip.syms, delta_o];
vals = [sys.descrip.model_params, delta_o_expr];

% Main matrices
sys.kin.C = subs(sys.kin.C, symbs, vals);
sys.kin.A = subs(sys.kin.A, symbs, vals);
sys.dyn.h = subs(sys.dyn.h, symbs, vals);
sys.dyn.M = subs(sys.dyn.M, symbs, vals);
