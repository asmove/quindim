syms mu_ b a_0 a_1 v_0i v_1i v_0 v_1;
syms mu_p1_s mu_p1_c mu_p1_v
syms mu_p2_s mu_p2_c mu_p2_v
syms mu_v_s mu_v_c mu_v_v
syms omega_s v_s
syms sign_sym(a) versor(u)
syms Fa(v) Ta1(w) Ta2(w)

sign_sym(a) = sign(a);

% Symbolic variables
syms kappa_1 alpha_1
syms dkappa_1 dalpha_1
syms kappa_2 alpha_2
syms dkappa_2 dalpha_2

syms kappa_3 alpha_3
syms dkappa_3 dalpha_3
syms kappa_4 alpha_4
syms dkappa_4 dalpha_4

dt = 1e-2;
tf = 100*dt;
tspan = 0:dt:tf;

% Holonomic expression

% Initial conditions
delta_i_num = 0;

L = sys.descrip.syms(end-2);

delta_o_expr = atan(L*tan(tan(delta_i)/(L + w*tan(delta_i))));
sys.kin.A = subs(sys.kin.A, delta_o, delta_o_expr);
sys.kin.C = subs(sys.kin.C, delta_o, delta_o_expr);
sys.kin.Cs = {sys.kin.C};

m = length(sys.kin.p{end});
p_val = 5;
qs = [0; 0; 0; delta_i_num; delta_o_expr; 0; 0; 0; 0];
ps = [0.1; 2; 2];

x0 = double(subs([qs; ps], [sys.descrip.syms.'; delta_i], ...
                 [sys.descrip.model_params.'; delta_i_num]));

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
model_symbs = symbs.';

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
model_params = params_ideal_';

aux_syms = [kappa_1; alpha_1; dkappa_1; dalpha_1;
            kappa_2; alpha_2; dkappa_2; dalpha_2;
            kappa_3; alpha_3; dkappa_3; dalpha_3;
            kappa_4; alpha_4; dkappa_4; dalpha_4;
            sys.descrip.u];

aux_vals = {@(t) 0; @(t) 0; @(t) 0; @(t) 0;
            @(t) 0; @(t) 0; @(t) 0; @(t) 0;
            @(t) 0; @(t) 0; @(t) 0; @(t) 0;
            @(t) 0; @(t) 0; @(t) 0; @(t) 0;
            @(t) 0; @(t) 0; @(t) 0; @(t) 0};

options.degree = 4;

odefun = @(t, x) df(t, x, aux_syms, aux_vals, ...
                    sys, v_i, v_o, v_cg_r, v_cg_l,...
                    model_symbs, model_params);

[~, xout_ideal] = ode('rk', odefun, x0, tspan, options);
xout_ideal = double(xout_ideal');

% Non-ideal modelling
params_nonideal_ = sys.descrip.model_params;
params_nonideal_(end+1) = 0;
params_nonideal_(end+1) = 1e-3;
params_nonideal_(end+1) = 1e-3;
params_nonideal_(end+1) = 0;
params_nonideal_(end+1) = 1e-3;
params_nonideal_(end+1) = 1e-3;
params_nonideal_(end+1) = 0;
params_nonideal_(end+1) = 1e-3;
params_nonideal_(end+1) = 1e-3;
params_nonideal_(end+1) = 0.05;
params_nonideal_(end+1) = 0.05;
model.model_params = params_nonideal_;

phi_ = 25;
A_delta = phi_*pi/180;
slip_perc = -0.5;

T = 1;
w_ = 2*pi/T;

% kappa: slippage percentage
% alpha: Angle displacement
aux_vals = {@(t) slip_perc*sin(w_*t); @(t) A_delta*sin(w_*t); @(t) w_*slip_perc*cos(w_*t); @(t) w_*A_delta*cos(w_*t); ...
            @(t) slip_perc*sin(w_*t); @(t) A_delta*sin(w_*t); @(t) w_*slip_perc*cos(w_*t); @(t) w_*A_delta*cos(w_*t); ...
            @(t) slip_perc*sin(w_*t); @(t) A_delta*sin(w_*t); @(t) w_*slip_perc*cos(w_*t); @(t) w_*A_delta*cos(w_*t); ...
            @(t) slip_perc*sin(w_*t); @(t) A_delta*sin(w_*t); @(t) w_*slip_perc*cos(w_*t); @(t) w_*A_delta*cos(w_*t); ...
            @(t) 0; @(t) 0; @(t) 0; @(t) 0};

odefun = @(t, x) df(t, x, aux_syms, aux_vals, sys, ...
                    v_i, v_o, v_cg_r, v_cg_l, model_symbs, model_params);

[~, xout_nonideal] = ode('rk', odefun, x0, tspan, options);
xout_nonideal = double(xout_nonideal');
