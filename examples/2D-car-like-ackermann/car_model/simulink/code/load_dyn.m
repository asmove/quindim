sys = calculate_jacobians(sys);
sys = update_jacobians(sys, sys.kin.C);

delta_sym = atan(tan(delta_i)/(1 + (varepsilon/2)*tan(delta_i)));

sys.kin.A = subs(sys.kin.A, delta, delta_sym);
sys.kin.C = subs(sys.kin.C, delta, delta_sym);

sys = dynamic_model(sys);

sys.kin.A = subs(sys.kin.A, delta, delta_sym);
sys.kin.C = subs(sys.kin.C, delta, delta_sym);
sys.dyn.h = subs(sys.dyn.h, delta, delta_sym);
sys.dyn.Z = subs(sys.dyn.Z, delta, delta_sym);
