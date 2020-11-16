% Holonomic expression
delta_o_expr = atan(L*tan(delta_i)/(L + w*tan(delta_i)));
% sys.kin.A = subs(sys.kin.A, delta_o, delta_o_expr);
% sys.kin.C = subs(sys.kin.C, delta_o, delta_o_expr);
% sys.kin.Cs = {sys.kin.C};

% Time [s]
dt = 0.1;
tf = 1;
t = 0:dt:tf;

% Initial conditions
delta_i_num = 0;

m = length(sys.kin.p{end});
p_val = 5;
qs = [0; 0; 0; delta_i_num; delta_o_expr; 0; 0; 0; 0];
ps = [0; 0.5; 1; 1];

qs0 = double(subs(qs, [sys.descrip.syms.'; delta_i], ...
                 [sys.descrip.model_params.'; delta_i_num]));
ps0 = double(subs(ps, [sys.descrip.syms.'; delta_i], ...
                 [sys.descrip.model_params.'; delta_i_num]));

x0 = double(subs([qs0; ps0], [sys.descrip.syms.'; delta_i], ...
                 [sys.descrip.model_params.'; delta_i_num]));

FontSize = 20;

if(~exist('SIM_SYS'))
else
    if(SIM_SYS)
        % System modelling
        u_func = @(t, x) zeros(length(sys.descrip.u), 1);
        sol = validate_model(sys, t, x0, u_func, false);

        x = t';
        y = sol';

        % Generalized coordinates
        plot_info_q.titles = repeat_str('', length(sys.kin.q));
        plot_info_q.xlabels = repeat_str('$t$ [s]', length(sys.kin.q));
        plot_info_q.ylabels = {'$x$', '$y$', '$\theta$', ...
                               '$\delta_i$', '$\delta_o$', ...
                               '$\phi_i$', '$\phi_o$', '$\phi_r$', '$\phi_l$'};
        plot_info_q.grid_size = [3, 3];
        
        [hfigs_states, axs] = my_plot(x, y(:, 1:9), plot_info_q);
        
        axs{1}{1}.FontSize = FontSize;
        axs{1}{2}.FontSize = FontSize;
        axs{1}{3}.FontSize = FontSize;
        axs{1}{4}.FontSize = FontSize;
        axs{1}{5}.FontSize = FontSize;
        axs{1}{6}.FontSize = FontSize;
        axs{1}{7}.FontSize = FontSize;
        axs{1}{8}.FontSize = FontSize;
        axs{1}{9}.FontSize = FontSize;
        
        plot_info_p.titles = repeat_str('', 4);
        plot_info_p.xlabels = repeat_str('$t$ [s]', 4);
        plot_info_p.ylabels = {'$\omega_{\theta}$', '$\omega_{\delta_o}$', ...
                               '$\omega_{\phi_o}$', '$\omega_{\phi_l}$'};
        plot_info_p.grid_size = [2, 2];

        % States plot
        [hfigs_speeds, axs] = my_plot(x, y(:, 10:end), plot_info_p);
        
        axs{1}{1}.FontSize = FontSize;
        axs{1}{2}.FontSize = FontSize;
        axs{1}{3}.FontSize = FontSize;
        axs{1}{4}.FontSize = FontSize;
        
        hfig_xy = my_figure();        
        plot(y(:, 1), y(:, 2));
        
        xlabel('$x$ $[m]$', 'interpreter', 'latex');
        ylabel('$y$ $[m]$', 'interpreter', 'latex');
        
        axis square
        
        % Energies plot
        hfig_energies = plot_energies(sys, x, y);
        hfig_consts = plot_constraints(sys, x, y);

        % Images
        saveas(hfigs_states(1), ['../images/states', num2str(1)], 'epsc');
        saveas(hfigs_speeds(1), ['../images/speeds', num2str(1)], 'epsc');
        saveas(hfig_xy, ['../images/xy_plot', num2str(1)], 'epsc');
        saveas(hfig_energies, '../images/energies', 'epsc');
        saveas(hfig_consts(1), ['../images/consts', num2str(1)], 'epsc');
    end
end