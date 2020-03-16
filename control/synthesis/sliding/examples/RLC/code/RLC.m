% Params and parameters estimation
model_params = sys.descrip.model_params.';
imprecision = perc*ones(size(sys.descrip.syms))';
params_lims = [(1-imprecision).*model_params, ...
               (1+imprecision).*model_params];

rel_qqbar = sys.kin.q;

[~, m] = size(sys.dyn.Z);
n = length(sys.kin.q);

% Tracking values

% Amplitude [A]
A = 0.1;

% angular speed [rad/s]
omega_ = 100;
w = 2*pi*omega_;

if(is_int)
    x_d = @(t) [-A*cos(w*t)/w^2; A*sin(w*t)/w; A*cos(w*t)];
    x_xp_d = @(t) [x_d(t); -A*w*sin(w*t)];
else
    x_d = @(t) [A*sin(w*t)/w; A*cos(w*t)];
    x_xp_d = @(t) [x_d(t); -A*w*sin(w*t)];
end

x_d0 = x_d(0);

% Control project design parameters
pole = -10;

m = 2;

% Initial conditions
if(is_dyn_bound)
    phi0 = terop(s0 > 0, u.phi0, -u.phi0);
    x0 = [0; 0; phi0];
else
    x0 = [0; 0];
end

% Initial conditions
if(is_int)
    poles = [-10, -5];
    coeffs = poly(poles);

    x0 = [x0; 0];

    alpha_ = coeffs(1);
    lambda_ = coeffs(2);
    mu_ = coeffs(3);

    int_e0 = x0(3) - x_d0(1);
    e0 = x0(1) - x_d0(2);
    ep0 = x0(2) - x_d0(3);

    s0 = alpha_*ep0 + lambda_*e0 + mu_*int_e0;

else
    poles = -10;
    coeffs = poly(poles);

    alpha_ = coeffs(1);
    lambda_ = coeffs(2);

    e0 = x0(1) - x_d0(1);
    ep0 = x0(2) - x_d0(2);

    s0 = alpha_*ep0 + lambda_*e0;
end

is_int = false;

% [s]
perc_T = 0.5;
T = 2*pi/w;
t_r = perc_T*T;

eta = double(abs(s0)/t_r);
etas = eta*ones(1, 1);

error = 1e-2; 
errorp = 1e-2;

u = sliding_underactuated(sys, etas, poles, ...
                          params_lims, rel_qqbar, ...
                          error, errorp, is_int);
u.switch_type = switch_type;

% Available switch functions
if(strcmp(switch_type, 'sat'))
    u.phi = u.phi;
elseif(strcmp(switch_type, 'hyst'))
    u.phi_min = -u.phi;
    u.phi_max = u.phi;
elseif(strcmp(switch_type, 'poly'))
    u.phi = u.phi;
    u.degree = 5;
else
end

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

u.Ms_struct.D = u.Ms_struct.F/u.Ms_struct.den_D;
u.Ms_struct.C = inv(eye(n)- u.Ms_struct.D);
u.Fs_struct.Fs_num = subs(u.Fs_struct.Fs_num, ...
                          [L R k L_hat R_hat k_hat], ...
                          [L_min R_max k_max L_max R_min k_min]);
u.Fs_struct.Fs = u.Fs_struct.Fs_num/u.Fs_struct.Fs_den;

n_diff = 50;
tf = T;
dt = perc_T*T/(n_diff+1);

tspan = (0:dt:tf)';
df_h = @(t, x) df_sys(t, x, x_xp_d, u, sys, tf);

u_func = @(t, x) output_sliding(t, x, x_xp_d, ...
                                u, sys, tf, ...
                                dt, is_dyn_bound, is_int);

sol = validate_model(sys, tspan, x0, u_func, is_dyn_bound || is_int);
x = sol';

[m, ~] = size(sys.dyn.Z);

% Plot part
img_path = '../imgs/';

t_len = length(tspan);

q_p_s = [sys.kin.q; sys.kin.p];
q_p_d_s = add_symsuffix([q_p_s; sys.kin.pp], '_d');

[~, m] = size(sys.dyn.Z);

q_p = [sys.kin.q; sys.kin.p];
n = length(q_p);

% States plot
references = [];
for i = 1:length(tspan)
    references = [references; x_d(tspan(i))'];
end

plot_config.titles = repeat_str('', n);
plot_config.xlabels = repeat_str('t [s]', n);
plot_config.ylabels = {'$Q$ [C]', '$i$ [A]'};
plot_config.grid_size = [2, 1];
plot_config.legends = {{'$x(t)$', '$x^{\star}(t)$'}, ...
                       {'$\dot{x}(t)$', '$\dot{x}^{\star}(t)$'}};
plot_config.pos_multiplots = [1, 2];
plot_config.markers = {{'-', 'r--'}, {'-', 'r--'}};

x_plots = {x, references};

hfigs_x = my_plot(tspan, x_plots, plot_config);

% Input plot
plot_config.titles = {'', ''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u$ [V]'};
plot_config.grid_size = [1, 1];

t_ = linspace(0, tf, length(u_control))';
hfigs_u = my_plot(t_, u_control, plot_config);

plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'Sliding function $s(t)$'};
plot_config.grid_size = [1, 1];
plot_config.legends = {'$s(t)$', '$\phi_-(t)$', '$\phi_+(t)$'};
plot_config.pos_multiplots = [1, 1];
plot_config.markers = {'-', 'r--', 'r--'};

% Sliding function plot
if(is_dyn_bound)
    phis = x(:, 3);
    s_plots = {sliding_s, [phis(1:end-1), -phis(1:end-1)]};

    t_ = linspace(0, tf, length(sliding_s))';
    hfigs_s = my_plot(t_, s_plots, plot_config);
else
    t_ = linspace(0, tf, length(sliding_s))';
    
    switch_types = {'sat', 'poly', 'hyst'};
    
    has_phi = false;
    for i = 1:length(switch_types)
        has_phi = has_phi || strcmp(switch_type, switch_types{i});
    end
        
    if(has_phi)
        if(strcmp(switch_type, 'hyst'))
            phi_maxs = u.phi_max*ones(size(t_));
            phi_mins = u.phi_min*ones(size(t_));
        else
            phi_mins = -u.phi*ones(size(t_));
            phi_maxs = u.phi*ones(size(t_));
        end
        phis = [phi_mins, phi_maxs];
        s_plots = {sliding_s, phis};

        hfigs_s = my_plot(t_, s_plots, plot_config);
    else
        plot_config.titles = {''};
        plot_config.xlabels = {'t [s]'};
        plot_config.ylabels = {'Sliding function $s(t)$'};
        plot_config.grid_size = [1, 1];

        hfigs_s = my_plot(t_, sliding_s, plot_config);
    end
end

path = '../imgs/';

% States
if(is_dyn_bound)
    filenames = {'x_phidyn_', 'u_phidyn_', 's_phidyn_'};
else
    filenames = {'x_', 'u_', 's_'}; 
end

hfigs = {hfigs_x, hfigs_u, hfigs_s};

for i = 1:length(filenames)
    hfig = hfigs{i};
    perc = num2str(perc);
    
    filepath = [path, filenames{i},  switch_type, '_', perc, '.eps'];
    saveas(hfig, filepath, 'epsc');
end

