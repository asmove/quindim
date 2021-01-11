function [hfig, K, P, F, T] = plot_energies(sys, time, states)
    n = length(time);
    sym_zeros = sym(zeros(n, 1));
    
    K = sym_zeros;
    P = sym_zeros;
    F = sym_zeros;
    T = sym_zeros;
    
    model_params = sys.descrip.model_params;
    symbs = sys.descrip.syms;
    
    [m, n] = size(symbs);
    
    if(m == 1)
        symbs = symbs.';
    end
    
    [m, n] = size(model_params);
    
    if(m == 1)
        model_params = model_params.';
    end
    
    sym_states_params = [sys.dyn.states; symbs];
    t_evals = 0;
    dts = [];
    
    % Threshold to calculate the average time interval
    THRES = 10;
    
    % Average time interval
    dt_mean = 0;
    
    % 30 min
    ACCEPTABLE_WAITTIME = 30*60;
    
    is_to_plot = true;
        
    for i = 1:THRES
        num_states_params = [states(i, :).'; model_params];
        
        t0 = tic();

        [K_val, U_val, ...
         F_val, T_val] = calc_energies(sys, sym_states_params, num_states_params);

        K(i) = K_val;
        U(i) = U_val;
        F(i) = F_val;
        T(i) = T_val;

        dt = toc(t0);

        t_evals = t_evals + 1;

        dts = [dts; dt];

        if(t_evals >= THRES)
            dt_mean = mean(dts);
        end
    end
    
    if(n*dt_mean >  ACCEPTABLE_WAITTIME)
        n_t = ceil(ACCEPTABLE_WAITTIME/dt_mean);

        tf = time(end);
        dt_new = tf/(n_t - 1);
        time_new = 0:dt_new:tf;

        [n, m] = size(states);

        states_red = zeros(n_t, m);
        
        wb = my_waitbar('Calculating energies...');
        for j = 1:n_t
            states_red(j, :) = interp1(time, states, time_new(j));
            wb.update_waitbar(j, n_t);
        end
        
        wb.close_window();
        
        
        wb = my_waitbar('Calculating energies...');
        for i = 1:n_t
            num_states_params = [states_red(i, :).'; model_params];

            t0 = tic();

            [K_val, U_val, F_val, T_val] = ...
                calc_energies(sys, sym_states_params, num_states_params);

            K(i) = K_val;
            U(i) = U_val;
            F(i) = F_val;
            T(i) = T_val;

            wb.update_waitbar(i, n_t);
        end
        
        wb.close_window();    
    else
        n_t = length(time);
        states_red = states;
    end
    
    plot_info.titles = {'', '', '', ''};
    plot_info.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
    plot_info.ylabels = {'$K(t)$', '$U(t)$', '$F(t)$', '$T(t)$'};
    plot_info.grid_size = [2, 2];

    energies = [K, P, F, T];

    hfig = my_plot(time, energies, plot_info); 
end

function [K_val, U_val, ...
          F_val, T_val] = calc_energies(sys, sym_states_params, ...
                                        num_states_params)
    K_val = my_subs(sys.dyn.K, sym_states_params, num_states_params);
    U_val = my_subs(sys.dyn.P, sym_states_params, num_states_params);
    F_val = my_subs(sys.dyn.F, sym_states_params, num_states_params);

    K_val = double(K_val);
    U_val = double(U_val);
    F_val = double(F_val);

    T_val = K_val + U_val - F_val;
end