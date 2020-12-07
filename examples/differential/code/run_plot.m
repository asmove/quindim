q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
x = [q, p];

states = simOut.states.signals.values;
q_speeds = simOut.q_speeds.signals.values;
t = simOut.tout;

plot_info.titles = {'', '', '', '', '', '', '', '', ''};
plot_info.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]', '$t$ [s]', ...
                     '$t$ [s]', '$t$ [s]', '$t$ [s]'};

plot_info.ylabels = {'$x$', '$y$', '$\theta$', '$\beta$', ...
                     '$\phi_r$', '$\phi_l$', '$\phi_s$', ...
                     '$p_1$', '$p_2$'};

plot_info.grid_size = [3, 3];

% States and energies plot
hfigs_states = my_plot(t, x, plot_info);

r_g = v_g/radius_g;
r_r = phip_r*R/radius_g;
r_l = phip_l*R/radius_g;
r_s = phip_s*R/radius_g;

r = [r_g, r_r, r_l, r_s];

wb = my_waitbar('Angular speed');

angspeeds = [];
for i = 1:length(t)
    symbs_i = [sys.kin.q; sys.kin.p{end}; ell; beta_g; sys.kin.qp; sys.descrip.syms.'];
    vals_i = [x(i, :).'; ell2_n; beta_g_n; qp_n; sys.descrip.model_params.'];
    rs_i = double(subs([r], symbs_i, vals_i));
    
    angspeeds = [angspeeds; rs_i];
    
    wb.update_waitbar(i, length(t));
end
    
wb.close_window();

angspeeds = {angspeeds(:, 1), angspeeds(:, 2:end)};

plot_info.titles = {''};
plot_info.xlabels = {'$t$ [s]'};
plot_info.ylabels = {'r'};
plot_info.grid_size = [1, 1];
plot_info.legends = {'$r_g$', '$r_r$', '$r_l$', '$r_s$'};
plot_info.pos_multiplots = [1, 1, 1];
plot_info.markers = {'b--', 'k--', 'm--', 'r--'};

% States and energies plot
[hfigs_angspeed, axs] = my_plot(t, angspeeds, plot_info);

axs{1}{1}.FontSize = 25;

plot_info.titles = {'Plot $x \times y$'};
plot_info.xlabels = {'$x$', };
plot_info.ylabels = {'$y$'};
plot_info.grid_size = [1, 1];

% States and energies plot
[hfigs_states, axs] = my_plot(x(:, 1), x(:, 2), plot_info);

axs{1}{1}.FontSize = 25;
axis square;

hfig_energies = plot_energies(sys, t, x);

sys.descrip.latex_origs = {{'xpp'}, {'\mathrm{xp}'}, {'x_pos'}, ...
                           {'ypp'}, {'\mathrm{yp}'}, {'y_pos'}, ...
                           {'\mathrm{thpp}'}, {'\mathrm{thp}'}, {'\mathrm{th}'}, ...
                           {'\mathrm{betapp}'}, {'\mathrm{betap}'}, {'\mathrm{beta}'}, ...
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
                          'p_1', 'p_2'};

hfig_consts = plot_constraints(sys, t, x);

% Energies
saveas(hfig_energies, '../imgs/energies', 'epsc');

saveas(hfigs_angspeed, '../imgs/angspeed', 'epsc');


for j = 1:length(hfigs_states)
   saveas(hfigs_states(j), ['../imgs/states', num2str(i)], 'epsc'); 
end
