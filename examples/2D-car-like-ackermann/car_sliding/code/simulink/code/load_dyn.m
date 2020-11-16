% Constraint condition
sys.descrip.is_constrained = true;

sys = calculate_jacobians(sys);
sys = update_jacobians(sys, sys.kin.C);

sys = dynamic_model(sys);
