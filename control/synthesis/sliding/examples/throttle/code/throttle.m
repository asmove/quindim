% --- Parameters limti values ---

% Params and parameters estimation
model_params = sys.descrip.model_params.';
imprecision = perc*ones(size(sys.descrip.syms))';
params_lims = [(1-imprecision).*model_params, ...
               (1+imprecision).*model_params];

rel_qqbar = sys.kin.q;

[~, m] = size(sys.dyn.Z);
n = length(sys.kin.q);

% --- Tracking values ---
T = 2.5;
scaler = 0.5;
t_r = scaler*T;

if(is_int)
    % [w(t), q(t), i(t)]
    x_d = @(t) [pi/6; 0];
    x_xp_d = @(t) [x_d(t); 0];
else
    % [q(t), i(t)]
    x_d = @(t) [pi/6; 0];
    x_xp_d = @(t) [x_d(t); 0];
end

x_d0 = x_d(0);

% --- Project design parameters ---

% [th(t); thp(t)]
x0 = [0; 0];

% Sliding function initial value and dynamic parameters
if(is_int)
    % [x(t); w(t)]
    x0 = [x0; 0];
    
    % Errors and its family
    wtilde_0 = x0(3) - x_d0(1);
    qtilde_0 = x0(1) - x_d0(2);
    itilde_0 = x0(2) - x_d0(3);
    
    % Percentage of reaching time [-]
    n_1 = 0.3;
    n_2 = 0.4;
    poles_1 = -1/(n_1*t_r);
    poles_2 = -1/(n_2*t_r);
    
    % Reaching poles
    poles = [poles_1, poles_2];
    coeffs = poly(poles);

    alpha_ = coeffs(1);
    lambda_ = coeffs(2);
    mu_ = coeffs(3);
    
    s0 = alpha_*itilde_0 + ...
         lambda_*qtilde_0 + ...
         mu_*wtilde_0;

else
    thtilde_0 = x0(1) - x_d0(1);
    thptilde_0 = x0(2) - x_d0(2);
    
    n = 0.4;
    poles = -1/(n*t_r);
    coeffs = poly(poles);

    alpha_ = coeffs(1);
    lambda_ = coeffs(2);

    e0 = x0(1) - x_d0(1);
    ep0 = x0(2) - x_d0(2);

    s0 = alpha_*thptilde_0 + ...
         lambda_*thtilde_0;
end

eta = double(abs(s0)/t_r);
etas = eta*ones(1, 1);

% Tracking precision
if(is_int)
    errors.error_w = 1e-3;
    errors.error_q = 1e-3;
    errors.error_qp = 1e-3;
else
    errors.error_q = 5e-3;
    errors.error_qp = 1e-3;
end

u = sliding_underactuated(sys, etas, poles, ...
                          params_lims, rel_qqbar, ...
                          errors, is_int, is_dyn_bound, ...
                          switch_type, options);

% Initial conditions
if(is_dyn_bound)
    x0 = [x0; u.phi0];
end

% XXX: Provide systematic to calculate C and D
% Controller gain 
L_min = params_lims(1, 1);
R_min = params_lims(2, 1);
k_min = params_lims(3, 1);

L_max = params_lims(1, 2);
R_max = params_lims(2, 2);
k_max = params_lims(3, 2);

symbs = sys.descrip.syms;
symbs_hat = add_symsuffix(sys.descrip.syms, '_hat');

L = symbs(1);
R = symbs(2);
k = symbs(3);

L_hat = symbs_hat(1);
R_hat = symbs_hat(2);
k_hat = symbs_hat(3);

u.Ms_struct.D = max(abs(u.Ms_struct.Omega_1 - 1), ...
                    abs(u.Ms_struct.Omega - 1));
n = length(u.Ms_struct.D);
u.Ms_struct.C = inv(eye(n)- u.Ms_struct.D);
u.Fs_struct.Fs_num = subs(u.Fs_struct.Fs_num, ...
                          [L R k L_hat R_hat k_hat], ...
                          [L_min R_max k_max L_max R_min k_min]);
u.Fs_struct.Fs = u.Fs_struct.Fs_num/u.Fs_struct.Fs_den;

x0 = double(x0);

if(is2sim)
    n_diff = 200;
    n_T = 1.5;
    tf = n_T*T;
    dt = scaler*T/(n_diff+1);

    tspan = (0:dt:tf)';
    df_h = @(t, x) df_sys(t, x, x_xp_d, u, sys, tf);

    u_func = @(t, x) output_sliding(t, x, x_xp_d, ...
                                    u, sys, dt, ...
                                    is_dyn_bound, is_int);
    
    is_dyn_control = is_dyn_bound || is_int;
    sol = validate_model(sys, tspan, x0, u_func, is_dyn_control);

    run('./plot_results.m');
end

