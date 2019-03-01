to = '../images/';

fnames = {'states_lin', 'predicted_lin'};
plot_sim(simOut_lin, to, fnames);

fnames = {'states_nlin', 'predicted_nlin'};
plot_sim(simOut_nlin, to, fnames);

% Comparison
fname = 'comparison';
w = get(simOut_lin, 'w');
xhat = get(simOut_lin, 'xhat');
x_lin = get(simOut_lin, 'x');
x_nlin = get(simOut_lin, 'x');

hfigcomp = plot_double_xxhat(w, x_lin, x_nlin, xhat, to, fname);
print(hfigcomp, [to, fname], '-depsc2', '-r0');

% Output
u_lin = get(simOut_lin, 'u');
u_nlin = get(simOut_nlin, 'u');

fname = 'ouput';
plot_double_u(u_lin, u_nlin, to, fname);
