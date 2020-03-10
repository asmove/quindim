clear_inner_close_all('~/github/Robotics4fun')
clear u_control;
clear sliding_s;
clear u
clear(func2str(@output_sliding))

vars = whos;

for i = 1:length(vars)
    var = vars(i);
    name = var.name;
    
    except_names = {'sys', 'vars', ...
                    'perc', 'switch_type', ...
                    'is_dyn_bound', 'perc', ...
                    'n_perc', 'n_percs', ...
                    'n_switch', 'n_switchs', ...
                    'is_dyn_bounds', 'switch_types', 'percs'};
    is_not_except_names = true;
    
    for j = 1:length(except_names)
        except_name = except_names{j};
        is_not_except_names = is_not_except_names & ~strcmp(name, except_name);
    end
    
    if(is_not_except_names)
        clear(name);
    end
end

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

% Amplitude [rad/s]
omega_ = 100;
w = 2*pi*omega_;
x_d = @(t) [A*sin(w*t)/w; A*cos(w*t)];
x_xp_d = @(t) [x_d(t); -A*w*sin(w*t)];

x_d0 = x_d(0);

% Control project design parameters
pole = -10;
poles = pole*ones(m, 1);

x0 = [0; 0];

E = equationsToMatrix(rel_qqbar, sys.kin.q);
alpha = E;
C = eig_to_matrix(poles);
lambda = -E*C;

ep0 = x0(2) - x_d0(2);
e0 = x0(1) - x_d0(1);
s0 = alpha*ep0 + lambda*e0;

% [s]
perc_T = 0.5;
T = 2*pi/w;
t_r = perc_T*T;

eta = double(abs(s0)/t_r);
etas = eta*ones(m, 1);

u = sliding_underactuated(sys, etas, poles, params_lims, rel_qqbar);
u.switch_type = switch_type;

% Available switch functions
phi = 0.01;
if(strcmp(switch_type, 'sat'))
    u.phi = phi;
elseif(strcmp(switch_type, 'hyst'))
    u.phi_min = -phi;
    u.phi_max = phi;
elseif(strcmp(switch_type, 'poly'))
    u.phi = phi;
    u.degree = 5;
else
end

% Initial values
if(is_dyn_bound)
    x0 = [0; 0; terop(s0 > 0, u.phi, -u.phi)];
else
    x0 = [0; 0];
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

% Initial conditions
n_diff = 50;
tf = T;
dt = perc_T*T/(n_diff+1);

tspan = 0:dt:tf;
df_h = @(t, x) df_sys(t, x, x_xp_d, u, sys, tf);

u_func = @(t, x) output_sliding(t, x, x_xp_d, ...
                                u, sys, tf, ...
                                dt, is_dyn_bound);

sol = validate_model(sys, tspan, x0, u_func, is_dyn_bound);
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
    
    if(strcmp(switch_type, 'sat') || strcmp(switch_type, 'poly'))
        phis = [-u.phi*ones(size(t_)), u.phi*ones(size(t_))];
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

