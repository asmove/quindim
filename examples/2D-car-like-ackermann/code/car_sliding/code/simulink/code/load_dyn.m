% Constraint condition
sys.descrip.is_constrained = true;

run('./consts_gen.m');

% Kinematic and dynamic model
sys = kinematic_model(sys);

sys = calculate_jacobians(sys);
sys = update_jacobians(sys, sys.kin.C);

sys = dynamic_model(sys);
