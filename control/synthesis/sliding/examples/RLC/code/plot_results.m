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
for i = 1:length(tspan)
    ref_i = x_d(tspan(i));
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

    x_plots = {x, references};
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

for i = 1:length(t_)
    t_i = t_(i);
    
    x_i = x(i, :);
    q_i = x_i(1);
    
    x_di = x_d(t_i);
    
    if(is_int)
        q_di = x_di(2);
    else
        q_di = x_di(1);
    end
    
    q_tilde = q_i - q_di;
    q_tildes = [q_tildes; q_tilde];
end

plot_config.titles = {'', ''};
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

if(is_dyn_bound)
    phis = x(:, 3);
    s_plots = {sliding_s, [phis(1:end-1), -phis(1:end-1)]};

    t_ = linspace(0, tf, length(sliding_s))';
    hfigs_s = my_plot(t_, s_plots, plot_config);
else
    t_ = linspace(0, tf, length(sliding_s))';
    
    switch_types_ = {'sat', 'hyst', 'poly'};
    
    has_phi = false;
    for i = 1:length(switch_types)
        has_phi = has_phi || strcmp(switch_type, switch_types_{i});
    end
    
    perc_s = 0.2;
    if(has_phi)
        if(strcmp(switch_type, 'hyst'))
            phi_mins = -u.phi0*ones(size(t_));
            phi_maxs = u.phi0*ones(size(t_));            
        else
            phi_mins = -u.phi0*ones(size(t_));
            phi_maxs = u.phi0*ones(size(t_));
        end
        
        phis = [phi_mins, phi_maxs];
        s_plots = {sliding_s, phis};

        hfigs_s = my_plot(t_, s_plots, plot_config);
        
        axis(double([0 tf (1 + perc_s)*s0 (1 + perc_s)*u.phi0]));
        
    else
        plot_config.titles = {''};
        plot_config.xlabels = {'t [s]'};
        plot_config.ylabels = {'Sliding function $s(t)$'};
        plot_config.grid_size = [1, 1];

        hfigs_s = my_plot(t_, sliding_s, plot_config);
        
        axis(double([0 tf (1 + perc_s)*s0 (1 + perc_s)*u.phi0]));
    end
end

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
    
    filepath = [path, filenames{i},  ...
                switch_type, '_', ...
                num2str(perc), '_',  ...
                int_text, '.eps'];
    saveas(hfig, filepath, 'epsc');
end