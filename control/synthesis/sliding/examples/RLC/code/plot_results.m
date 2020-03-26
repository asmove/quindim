x = sol';

[m, ~] = size(sys.dyn.Z);

% Plot part
img_path = '../imgs/';

t_len = length(tspan);

q_p_s = [sys.kin.q; sys.kin.p];
q_p_d_s = add_symsuffix([q_p_s; sys.kin.pp], '_d');

[~, m] = size(sys.dyn.Z);

q_p = [sys.kin.q; sys.kin.p];
[m, n] = size(x);

% States plot
references = [];
for k = 1:length(tspan)
    ref_i = x_d(tspan(k));
    references = [references; ref_i'];
end

if(is_int)
    plot_config.titles = repeat_str('', n);
    plot_config.xlabels = repeat_str('t [s]', n);
    plot_config.ylabels = {'$w(t)$ [C s]', ...
                           '$q(t)$ [C]', ...
                           '$i(t)$ [A]'};
    plot_config.grid_size = [3, 1];
    plot_config.legends = {{'$w(t)$', '$w^{\star}(t)$'}, ...
                           {'$q(t)$', '$q^{\star}(t)$'}, ...
                           {'$i(t)$', '$i^{\star}(t)$'}};
    plot_config.pos_multiplots = [1, 2, 3];
    plot_config.markers = {{'-', 'r--'}, ...
                           {'-', 'r--'}, ...
                           {'-', 'r--'}};

    x_plots = {[x(:, 3), x(:, 1:2)], references};

else
    plot_config.titles = repeat_str('', n);
    plot_config.xlabels = repeat_str('t [s]', n);
    plot_config.ylabels = {'$q(t)$ [C]', ...
                           '$i(t)$ [A]'};
    plot_config.grid_size = [2, 1];
    plot_config.legends = {{'$q(t)$', '$q^{\star}(t)$'}, ...
                           {'$i(t)$', '$i^{\star}(t)$'}};
    plot_config.pos_multiplots = [1, 2];
    plot_config.markers = {{'-', 'r--'}, ...
                           {'-', 'r--'}};

    x_plots = {x(:, 1:2), references};
end

hfigs_x = my_plot(tspan, x_plots, plot_config);

% Input plot
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u$ [V]'};
plot_config.grid_size = [1, 1];

t_ = linspace(0, tf, length(u_control))';
hfigs_u = my_plot(t_, u_control, plot_config);

% Gains plot
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$K$'};
plot_config.grid_size = [1, 1];

t_ = linspace(0, tf, length(k_gains))';
hfigs_K = my_plot(t_, k_gains, plot_config);

% q_tilde plot
q_tildes = [];
[m, ~] = size(x);
t_ = linspace(0, tf, m)';

if(is_int)
    % Errors and its family
    w0 = x0(3) - x_d0(1);
    q0 = x0(1) - x_d0(2);
    i0 = x0(2) - x_d0(3);
    
    q_tildes = [];
    for j = 1:length(t_)
        t_i = t_(j);

        x_i = x(j, :);
        x_di = x_d(t_i);
        q_i = x_i(1);
        q_di = x_di(2);

        q_tilde = q_i - q_di;
        q_tildes = [q_tildes; q_tilde];
    end
    
    s0 = abs(alpha_)*abs(error_i) + ...
         abs(lambda_)*abs(error_q) + ...
         abs(mu_)*abs(error_w);
else
    q0 = x0(1) - x_d0(1);
    i0 = x0(2) - x_d0(2);
    
    q_tildes = [];
    for j = 1:length(t_)
        t_i = t_(j);

        x_i = x(j, :);
        x_di = x_d(t_i);
        q_i = x_i(1);
        q_di = x_di(1);

        q_tilde = q_i - q_di;
        q_tildes = [q_tildes; q_tilde];
    end
    
    A = [0, 1; ...
         -mu_/alpha_, -lambda_/alpha_];
    C = [1, 0];
    x0_ = [q0; w0];
    
    s0 = abs(alpha_)*abs(error_i) + ...
         abs(lambda_)*abs(error_q);
end

plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$\tilde{q}(t)$ [C]'};
plot_config.grid_size = [1, 1];

hfigs_qtilde = my_plot(t_, q_tildes, plot_config);

% Sliding function plot
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'Sliding function $s(t)$'};
plot_config.grid_size = [1, 1];
plot_config.legends = {'$s(t)$', '$\phi_-(t)$', '$\phi_+(t)$'};
plot_config.pos_multiplots = [1, 1];
plot_config.markers = {'-', 'r--', 'r--'};

has_phi = false;
switch_types_ = {'sat', 'hyst', 'poly'};

for i = 1:length(switch_types_)
    isin_switch_types = strcmp(switch_type, switch_types_{i});
    has_phi = has_phi || isin_switch_types;
end

if(has_phi)
    perc_s = 0.2;
    
    t_ = linspace(0, tf, m-1)';
    
    if(is_dyn_bound)
        phi = x(:, 3);
        phi_min = -phi;
        phi_max = phi;

        phis = [phi_min, phi_max];
        phis = phis(1:end-1, :);
    else
        m = length(sliding_s);
        t_ = linspace(0, tf, m)';

        phi_mins = -u.phi0*ones(m, 1);
        phi_maxs = u.phi0*ones(m, 1);

        phis = [phi_mins, phi_maxs];
    end

    s_plots = {sliding_s, phis};
    hfigs_s = my_plot(t_, s_plots, plot_config);
else
    t_ = linspace(0, tf, length(sliding_s))';

    plot_config.titles = {''};
    plot_config.xlabels = {'t [s]'};
    plot_config.ylabels = {'Sliding function $s(t)$'};
    plot_config.grid_size = [1, 1];

    hfigs_s = my_plot(t_, sliding_s, plot_config);
end

% perc_s = 0.2;
% xlim_ = (1 + perc_s)*(-abs(s0));
% ylim_ = (1 + perc_s)*(abs(s0));
% axis(double([0 tf xlim_ ylim_]));

path = '../imgs/';

% States
if(is_dyn_bound)
    filenames = {'x_phidyn_', 'u_phidyn_', 's_phidyn_', ...
                 'k_phidyn_', 'qtilde_phidyn_'};
else
    filenames = {'x_', 'u_', 's_', 'k_', 'q_tilde'}; 
end

hfigs = {hfigs_x, hfigs_u, hfigs_s, hfigs_K, hfigs_qtilde};

for i = 1:length(filenames)
    hfig = hfigs{i};
    
    int_text = terop(is_int, 'int', 'nint');
    
    path_ = [path, switch_type];
    
    filepath = [path_, '/', filenames{i},  ...
                switch_type, '_', ...
                num2str(perc), '_',  ...
                int_text, '.eps'];
    saveas(hfig, filepath, 'epsc');
end