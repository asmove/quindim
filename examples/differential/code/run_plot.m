% States and energies plot
plot_info.titles = {'', '', '', '', '', '', '', '', ''};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]', '$t$ [s]'};

plot_info.ylabels = {'$x$', '$y$', '$\theta$', '$\beta$', ...
                     '$\phi_r$', '$\phi_l$', '$\phi_s$', ...
                     '$\omega_{\beta}$', '$\omega_{\phi_l}$'};

plot_info.grid_size = [3, 3];

hfigs_states = my_plot(t, x, plot_info);

% Angular speed and wheel radius
R = sys.descrip.syms(6);

r_g = v_g/radius_g;
r_r = phip_r*R/radius_r;
r_l = phip_l*R/radius_l;
r_s = phip_s*R_s/radius_s;

r = [r_g, r_r, r_l, r_s];
radius = [radius_g, radius_r, radius_l, radius_s];

wb = my_waitbar('Angular speed');

symbs = [sys.kin.q; sys.kin.p{end}; sys.descrip.syms.'];

angspeeds = [];
radii = [];
qp_s = [];

for i = 1:length(t)
    vals = [x(i, :).'; sys.descrip.model_params.'];
    
    qp_n = subs(sys.kin.C*sys.kin.p{end}, symbs, vals);
    
    qp_s = [qp_s; qp_n.'];
    
    symbs_ = [symbs; sys.kin.qp];
    vals_ = [vals; qp_n];
    
    ell_n = subs(sqrt(ell2), symbs, vals);
    beta_g_n = subs(beta_g_val, symbs, vals);
    
    vals_ = subs(vals_, [beta_g; ell], [beta_g_n; ell_n]);
    
    symbs_i = [symbs_; beta_g; ell];
    vals_i = vpa([vals_; beta_g_n; ell_n]); 
    
    if(mod(x(i, 4), 2*pi) == 0)
        rs_i = [0, 0, 0, 0];
        radii_i = [0, 0, 0, 0];
    else
        rs_i = double(subs(r, symbs_i, vals_i));
        radii_i = double(subs(radius, symbs_i, vals_i));
    end
    
    radii = [radii; radii_i];
    angspeeds = [angspeeds; rs_i];    
    
    wb.update_waitbar(i, length(t));
end

qp_s = double(qp_s);
radii = double(radii);
angspeeds = double(angspeeds);

wb.close_window();

% States and energies plot
plot_info.titles = {'', '', '', ''};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info.ylabels = {'$\dot{x}$', '$\dot{y}$', '$\dot{\theta}$'};
plot_info.grid_size = [1, 3];

[hfigs_xyth, axs] = my_plot(t, qp_s(:, 1:3), plot_info);

axs{1}{1}.FontSize = 25;
axs{1}{2}.FontSize = 25;
axs{1}{3}.FontSize = 25;

% States and energies plot
plot_info.titles = { '', '', '', '', ''};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};

plot_info.ylabels = {'$\dot{\beta}$', '$\dot{\phi_r}$', ...
                     '$\dot{\phi_l}$', '$\dot{\phi_s}$'};

plot_info.grid_size = [2, 2];

[hfigs_beta_rls, axs] = my_plot(t, qp_s(:, 4:7), plot_info);

axs{1}{1}.FontSize = 25;
axs{1}{2}.FontSize = 25;
axs{1}{3}.FontSize = 25;
axs{1}{4}.FontSize = 25;

% Angular speed
angspeeds_ = {angspeeds(:, 1), angspeeds(:, 2:end)};

plot_info.titles = {''};
plot_info.xlabels = {'$t$ [s]'};
plot_info.ylabels = {'r'};
plot_info.grid_size = [1, 1];
plot_info.legends = {'$r_g$', '$r_r$', '$r_l$', '$r_s$'};
plot_info.pos_multiplots = [1, 1, 1];
plot_info.markers = {'b--', 'k--', 'm--', 'r--'};

[hfigs_angspeed, axs] = my_plot(t, angspeeds_, plot_info);

axs{1}{1}.FontSize = 25;
axis square;
axs{1}{1}.Legend.Location = 'bestoutside';

% States and energies plot
idx_radii = 10;
radii_ = {radii(idx_radii:end, 1), radii(idx_radii:end, 2:end)};

plot_info.titles = {''};
plot_info.xlabels = {'$t$ [s]'};
plot_info.ylabels = {'Radii'};
plot_info.grid_size = [1, 1];
plot_info.legends = {'$R_g$', '$R_r$', '$R_l$', '$R_s$'};
plot_info.pos_multiplots = [1, 1, 1];
plot_info.markers = {'b--', 'k--', 'm--', 'r--'};

[hfigs_radii, axs] = my_plot(t(idx_radii:end), radii_, plot_info);

axs{1}{1}.FontSize = 25;

% States and energies plot
plot_info.titles = {'Plot $x \times y$'};
plot_info.xlabels = {'$x$', };
plot_info.ylabels = {'$y$'};
plot_info.grid_size = [1, 1];

[hfigs_states, axs] = my_plot(x(:, 1), x(:, 2), plot_info);

axs{1}{1}.FontSize = 25;
axis square;

hfig_energies = plot_energies(sys, t, x);

sys.descrip.latex_origs = {{'xpp'}, {'\mathrm{xp}'}, {'x_pos'}, ...
                           {'ypp'}, {'\mathrm{yp}'}, {'y_pos'}, ...
                           {'\mathrm{thpp}'}, {'\mathrm{thp}'}, {'\mathrm{th}'}, ...
                           {'\mathrm{betapp}'}, {'\mathrm{betap}'}, {'\mathrm{beta_}'}, ...
                           {'\mathrm{phipp}_{s}'}, {'\mathrm{phip}_{s}'}, {'\mathrm{phi}_{s}'}, ...
                           {'\mathrm{phipp}_{r}'}, {'\mathrm{phip}_{r}'}, {'\mathrm{phi}_{r}'}, ...
                           {'\mathrm{phipp}_{l}'}, {'\mathrm{phip}_{l}'}, {'\mathrm{phi}_{l}'}, ...
                           {'\mathrm{p1}'}, {'\mathrm{p2}'}};

sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', 'x', ...
                          '\ddot{y}', '\dot{y}', 'y', ...
                          '\ddot{\theta}', '\dot{\theta}', '\theta', ...
                          '\ddot{\beta}', '\dot{\beta}', '\beta', ...
                          '\ddot{\phi}_{s}', '\dot{\phi}_{s}', '\phi_{s}', ...
                          '\ddot{\phi}_{r}', '\dot{\phi}_{r}', '\phi_{r}', ...
                          '\ddot{\phi}_{l}', '\dot{\phi}_{l}', '\phi_{l}', ...
                          '\omega_1', 'p_2'};

hfig_consts = plot_constraints(sys, t, x);

% Energies
saveas(hfigs_angspeed, '../imgs/ang_speed', 'epsc');
saveas(hfigs_radii, '../imgs/radii', 'epsc');
saveas(hfig_energies, '../imgs/energies', 'epsc');
saveas(hfigs_angspeed, '../imgs/angspeed', 'epsc');

for j = 1:length(hfigs_states)
   saveas(hfigs_states(j), ['../imgs/states', num2str(i)], 'epsc'); 
end
