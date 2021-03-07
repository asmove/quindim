run('./load_params.m');
run('./load_model.m');
run('./load_delay.m');
run('./load_integrator.m');
run('./load_observer.m');

Ctilde = Ctilde(1, 1:2);

mean_val = 0;
var_val = 0.1;