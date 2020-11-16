
mu_a = 0.1;
mu_b = 0.5;
mu_c = 0.5;
omega_s = 0.02;

omega = (-0.5:0.001:0.5)';

T_coul = mu_a*sign(omega);
T_visc = mu_b*omega;
T_str = mu_c*(omega/omega_s).*exp(-(omega/omega_s).^2);

T = T_coul + T_visc + T_str;

plot_config.titles = {''};
plot_config.xlabels = {'$\omega [\frac{rad}{s}]$'};
plot_config.ylabels = {'$F [N]$'};
plot_config.grid_size = [1, 1];
plot_config.legends = {'Resulting friction force', ...
                       'Coulomb friction force', ...
                       'Viscuous frictin force', ...
                       'Stribeck friction force'};
plot_config.pos_multiplots = [1, 1, 1];
plot_config.markers = {'-', '--', 'k--', 'b--'};

Ts = {T, [T_coul, T_visc, T_str]};

h_const = my_plot(omega, Ts, plot_config);

axis('square');
h_const.CurrentAxes.FontSize = 20;

saveas(h_const, ['../imgs/stribeck', '.eps'], 'epsc')