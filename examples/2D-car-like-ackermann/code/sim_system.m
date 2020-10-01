% Time [s]
dt = 0.01;
tf = 1;
t = 0:dt:tf;

% Initial conditions
delta_i_num = 0.1;
qs = [0; 0; 0; delta_i_num; delta_o_expr; 0; 0; 0; 0];
ps = [0; 0; 1; 1];
x0 = double(subs([qs; ps], ...
                 [sys.descrip.syms.'; delta_i], ...
                 [sys.descrip.model_params.'; delta_i_num]));

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
        
        hfigs_states = my_plot(x, y(:, 1:9), plot_info_q);

        plot_info_p.titles = repeat_str('', 4);
        plot_info_p.xlabels = repeat_str('$t$ [s]', 4);
        plot_info_p.ylabels = {'$p_1$', '$p_2$', '$p_3$', '$p_4$'};
        plot_info_p.grid_size = [2, 2];

        % States plot
        hfigs_speeds = my_plot(x, y(:, 10:end), plot_info_p);
        
        % Energies plot
        hfig_energies = plot_energies(sys, x, y);
        hfig_consts = plot_constraints(sys, x, y);

        % Images
        saveas(hfig_energies, '../images/energies', 'epsc');
        saveas(hfigs_states(1), ['../images/states', num2str(1)], 'epsc'); 
        saveas(hfigs_speeds(1), ['../images/speeds', num2str(1)], 'epsc'); 
        saveas(hfig_consts(1), ['../images/consts', num2str(1)], 'epsc'); 
    end
end