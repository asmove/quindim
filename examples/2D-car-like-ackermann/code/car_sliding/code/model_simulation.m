dt = 1e-3;
tf = 1;
tspan = 0:dt:tf;

x0 = [0; 0; 0; 0; 6; 30];

% Friction coefficients
symbs = sys.descrip.syms;
symbs(end+1) = mu_v_s;
symbs(end+1) = mu_v_c;
symbs(end+1) = mu_v_v;
symbs(end+1) = mu_p1_s;
symbs(end+1) = mu_p1_c;
symbs(end+1) = mu_p1_v;
symbs(end+1) = mu_p2_s;
symbs(end+1) = mu_p2_c;
symbs(end+1) = mu_p2_v;
symbs(end+1) = omega_s;
symbs(end+1) = v_s;
model.symbs = symbs;

% Ideal modelling
params_ideal_ = sys.descrip.model_params;
params_ideal_(end+1) = 0;
params_ideal_(end+1) = 0;
params_ideal_(end+1) = 0;
params_ideal_(end+1) = 0;
params_ideal_(end+1) = 0;
params_ideal_(end+1) = 0;
params_ideal_(end+1) = 0;
params_ideal_(end+1) = 0;
params_ideal_(end+1) = 0;
params_ideal_(end+1) = 0.05;
params_ideal_(end+1) = 0.05;
model.model_params = params_ideal_;

model.plant = [C_1delta*p; inv(H)*(f + f_i + f_ni)];
model.plant = subs(model.plant, ...
                   [sys.descrip.syms, sys.descrip.u.'], ...
                   [sys.descrip.model_params, 0, 0]);

aux_syms_ideal = [kappa; alpha; dkappa; dalpha];
aux_vals_ideal = {@(t) 0; @(t) 0; @(t) 0; @(t) 0};

options.degree = 4;
odefun = @(t, x) df(t, x, model, aux_syms_ideal, aux_vals_ideal);
[~, xout_ideal] = ode('rk', odefun, x0, tspan, options);
xout_ideal = double(xout_ideal');

% Non-ideal modelling
params_nonideal_ = sys.descrip.model_params;
params_nonideal_(end+1) = 0;
params_nonideal_(end+1) = 1e-4;
params_nonideal_(end+1) = 1e-4;
params_nonideal_(end+1) = 0;
params_nonideal_(end+1) = 1e-4;
params_nonideal_(end+1) = 1e-4;
params_nonideal_(end+1) = 0;
params_nonideal_(end+1) = 1e-4;
params_nonideal_(end+1) = 1e-4;
params_nonideal_(end+1) = 0.05;
params_nonideal_(end+1) = 0.05;
model.model_params = params_nonideal_;

model.plant = [C_1delta*p; ...
               inv(H)*(f + f_i + f_ni)];
model.plant = subs(model.plant, ...
                   [sys.descrip.syms, sys.descrip.u.'], ...
                   [sys.descrip.model_params, 0, 0]);

phi_ = 45;
A_delta = phi_*pi/180;
slip_perc = -0.5;

T = 1;
w_ = 2*pi/T;

% kappa: slippage percentage
% alpha: Angle displacement
aux_syms_nonideal = [kappa; alpha; dkappa; dalpha];
aux_vals_nonideal = {@(t) slip_perc*sin(w_*t); @(t) A_delta*sin(w_*t); ...
                     @(t) w_*slip_perc*cos(w_*t); @(t) w_*A_delta*cos(w_*t)};

odefun = @(t, x) df(t, x, model, aux_syms_nonideal, aux_vals_nonideal);

[~, xout_nonideal] = ode('rk', odefun, x0, tspan, options);
xout_nonideal = double(xout_nonideal');
