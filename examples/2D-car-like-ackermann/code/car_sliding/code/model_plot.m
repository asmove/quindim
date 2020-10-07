base_legend = {'Ideal', 'Non-ideal'};
base_marker = {'-', '--'};

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = {'t [s]', 't [s]', 't [s]', 't [s]'};
plot_config.ylabels = {'$x(t)$', '$y(t)$', '$\theta(t)$', '$\phi(t)$'};
plot_config.grid_size = [2, 2];
plot_config.legends = {base_legend, base_legend, base_legend, base_legend};
plot_config.pos_multiplots = [1, 2, 3, 4];
plot_config.markers = {base_marker, base_marker, base_marker, base_marker};

qs = {xout_ideal(:, 1:4), xout_nonideal(:, 1:4)};

[h_coords, axs] = my_plot(tspan, qs, plot_config);

FontSize = 25;
axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;
axs{1}{3}.FontSize = FontSize;
axs{1}{4}.FontSize = FontSize;

plot_config.titles = repeat_str('', 2);
plot_config.xlabels = {'t [s]', 't [s]'};
plot_config.ylabels = {'$\omega_\theta(t)$', '$\omega_\phi(t)$'};
plot_config.grid_size = [1, 2];
plot_config.legends = {base_legend, base_legend};
plot_config.pos_multiplots = [1, 2];
plot_config.markers = {base_marker, base_marker};

ps = {xout_ideal(:, 5:6), xout_nonideal(:, 5:6)};

[h_speeds, axs] = my_plot(tspan, ps, plot_config);

axs{1}{1}.XLim = [0, tf];
axs{1}{1}.YLim = [0, max(xout_nonideal(:, 5))];
axs{1}{2}.XLim = [0, tf];
axs{1}{2}.YLim = [0, max(xout_nonideal(:, 6))];

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;

A = [A1; A2];
consts_ideal = [];
consts_non_ideal = [];

wb = my_waitbar('Constraints update');

for i = 1:length(t)
    alpha_beta_ideal_i = [];
    alpha_beta_nonideal_i = [];
    
    for j = 1:length(aux_vals_ideal)
        alpha_beta_ideal_func = aux_vals_ideal(j);
        alpha_beta_ideal_func = alpha_beta_ideal_func{1};
        alpha_beta_nonideal_func = aux_vals_nonideal(j);
        alpha_beta_nonideal_func = alpha_beta_nonideal_func{1};
        
        alpha_beta_ideal_i = [alpha_beta_ideal_i, ...
                              alpha_beta_ideal_func(t(i))];
        alpha_beta_nonideal_i = [alpha_beta_nonideal_i, ...
                                 alpha_beta_ideal_func(t(i))];
                        
    end
    
    qp_ideal_i = subs(C_1delta*p, ...
                      [q; p; aux_syms_ideal], ...
                      [xout_ideal(i, :)'; alpha_beta_ideal_i']);
    qp_nonideal_i = subs(C_1delta*p, ...
                         [q; p; aux_syms_nonideal], ...
                         [xout_ideal(i, :)'; alpha_beta_nonideal_i']);
    
    consts_ideal_i = subs(A*qp_ideal_i, ...
                          [q; p; sys.descrip.syms.'], ...
                          [xout_ideal(i, :)'; sys.descrip.model_params.']);
    consts_non_ideal_i = subs(A*qp_nonideal_i, ...
                              [q; p; sys.descrip.syms.'], ...
                              [xout_nonideal(i, :)'; sys.descrip.model_params.']);
    
    consts_ideal = [consts_ideal; consts_ideal_i.'];
    consts_non_ideal = [consts_non_ideal; consts_non_ideal_i.'];
    
    wb.update_waitbar(i, length(t));
end

plot_config.titles = repeat_str('', 2);
plot_config.xlabels = {'t [s]', 't [s]'};
plot_config.ylabels = {'$a_1^\top \, \dot{q}$', ...
                       '$a_2^\top \, \dot{q}$'};
plot_config.grid_size = [1, 2];
plot_config.legends = {base_legend, base_legend};
plot_config.pos_multiplots = [1, 2];
plot_config.markers = {base_marker, base_marker};

consts = {double(consts_ideal), double(consts_non_ideal)};

[h_const, axs] = my_plot(t, consts, plot_config);

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;

Qc_i_ideal = [];
Qc_i_nonideal = [];
Qc_ni_ideal = [];
Qc_ni_nonideal = [];

wb = my_waitbar('Forces');

for i = 1:length(t)
    xout_ideal_i = xout_ideal(i, :);
    xout_nonideal_i = xout_nonideal(i, :);
    
    aux_vals_ideals = [];
    for j = 1:length(aux_vals_ideal)
        aux_vals_ideal_j = aux_vals_ideal(j);
        aux_vals_ideal_j = aux_vals_ideal_j{1};
        aux_vals_ideals = [aux_vals_ideals, aux_vals_ideal_j(t(i))];
    end
    
    aux_vals_nonideals = [];
    for j = 1:length(aux_vals_ideal)
        aux_vals_nonideal_j = aux_vals_nonideal(j);
        aux_vals_nonideal_j = aux_vals_nonideal_j{1};
        aux_vals_nonideals = [aux_vals_nonideals, aux_vals_nonideal_j(t(i))];
    end
    
    symbs = [model.symbs, aux_syms_ideal.', model.q.', model.p.', sys.descrip.u.'];
    params_ideal = [model.model_params, aux_vals_ideals, xout_ideal_i, 0, 0];
    params_nonideal = [model.model_params, aux_vals_nonideals, xout_nonideal_i, 0, 0];
    
    Qc_i_ideal_ = subs(Qc_i, symbs, params_ideal).';
    Qc_i_nonideal_ = subs(Qc_i, symbs, params_nonideal).';
    Qc_ni_ideal_ = subs(Qc_ni, symbs, params_ideal).';
    Qc_ni_nonideal_ = subs(Qc_ni, symbs, params_nonideal).';
    
    Qc_i_ideal = [Qc_i_ideal; Qc_i_ideal_];
    Qc_i_nonideal = [Qc_i_nonideal; Qc_i_nonideal_];
    Qc_ni_ideal = [Qc_ni_ideal; Qc_ni_ideal_];
    Qc_ni_nonideal = [Qc_ni_nonideal; Qc_ni_nonideal_];

    wb.update_waitbar(i, length(t));
end

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = repeat_str('t [s]', 4);
plot_config.ylabels = {'$F_x \, [N]$', ...
                       '$F_y \, [N]$', ...
                       '$\tau_\theta \, [N.m]$', ...
                       '$\tau_\phi \, [N.m]$'};
plot_config.grid_size = [2, 2];
plot_config.legends = {base_legend, base_legend, base_legend, base_legend};
plot_config.pos_multiplots = [1, 2, 3, 4];
plot_config.markers = {base_marker, base_marker, base_marker, base_marker};

Qcs = {Qc_i_ideal, Qc_i_nonideal};

[h_Qc_i, axs] = my_plot(t, Qcs, plot_config);

[ax1, h1] = suplabel('Ideal constraints force', 't');
set(h1, 'interpreter', 'latex')

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;
axs{1}{3}.FontSize = FontSize;
axs{1}{4}.FontSize = FontSize;
ax1.FontSize = FontSize;

base_legend = {'Ideal', 'Non-ideal'};
base_marker = {'-', '--'};

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = repeat_str('t [s]', 4);
plot_config.ylabels = {'$F_x \, [N]$', ...
                       '$F_y \, [N]$', ...
                       '$\tau_\theta \, [N.m]$', ...
                       '$\tau_\phi \, [N.m]$'};
plot_config.grid_size = [2, 2];
plot_config.legends = {base_legend, base_legend, base_legend, base_legend};
plot_config.pos_multiplots = [1, 2, 3, 4];
plot_config.markers = {base_marker, base_marker, base_marker, base_marker};

Qcs = {Qc_ni_ideal, Qc_ni_nonideal};

[h_Qc_ni, axs] = my_plot(t, Qcs, plot_config);

[ax1, h1] = suplabel('Non-ideal constraints force', 't');
set(h1, 'interpreter', 'latex')

axs{1}{1}.FontSize = FontSize;
axs{1}{2}.FontSize = FontSize;
axs{1}{3}.FontSize = FontSize;
axs{1}{4}.FontSize = FontSize;
ax1.FontSize = FontSize;

h_xy = my_figure();

axs = plot(xout_ideal(:, 1), xout_ideal(:, 2), '-');
hold on;
plot(xout_nonideal(:, 1), xout_nonideal(:, 2), '--');
hold off;

legend(base_legend, 'interpreter', 'latex');
xlabel('x [m]', 'interpreter', 'latex');
ylabel('y [m]', 'interpreter', 'latex');

axs.Parent.FontSize = FontSize;

axis equal
grid

files_ = ls([pwd, '/..']);
files = strsplit(files_);

has_imgs = false;
for i = 1:length(files)
    file_ = files{i};
    if(strcmp(file_, 'imgs'))
        has_imgs = true;
    end
end

if(~has_imgs)
    mkdir([pwd, '/imgs']);
end

saveas(h_const, ['../imgs/constraints', '.eps'], 'epsc')
saveas(h_coords, ['../imgs/states', '.eps'], 'epsc')
saveas(h_speeds, ['../imgs/speeds', '.eps'], 'epsc')
saveas(h_xy, ['../imgs/xy_proj', '.eps'], 'epsc')
saveas(h_Qc_i, ['../imgs/ideal_forces', '.eps'], 'epsc')
saveas(h_Qc_ni, ['../imgs/nonideal_forces', '.eps'], 'epsc')

