clear all
close all
clc

zeta = 1;

v0 = 1;
tspan = 0:0.05:5;

ps = 1:5;
vs = [];
for p = ps
    my_fun = @(t, v) df_lyapunov(t, v, zeta, p);
    
    v_sol = my_ode45(my_fun, tspan, v0);
    
    vs = [vs, v_sol'];
    delete(findall(0,'type','figure','tag','TMWWaitbar'));
end

plot_config.titles = {'Lyapunov function $v(t, p)$'};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$v(t)$'};
plot_config.grid_size = [1, 1];
plot_config.legends = strsplit(num2str(ps));
plot_config.pos_multiplots = ones(1, length(ps)-1);
plot_config.markers = {'b', 'm', 'k', 'c', 'r'};

ys = {vs(:, 1), vs(:, 2:end)};

hfig_lyapunov = my_plot(tspan, ys, plot_config);

lyapunov_path = '../imgs/lyapunovs.eps';
saveas(hfig_lyapunov, lyapunov_path, 'epsc');