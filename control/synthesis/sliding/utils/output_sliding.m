function varargout = output_sliding(t, x, q_p_ref_fun, u_struct, ...
                                    sys, dt, is_dyn_bound, is_int)
    % ----------------------------------------------------------------- %
    persistent u_acc s_acc counter k_gains curr_s_sign;
    persistent phi0 t_curr;
    
    [~, m] = size(sys.dyn.Z);
    n = length(sys.kin.q);

    if(isempty(counter) || t == dt)
        counter = 0;
    end
    
    if(isempty(u_acc) || t == dt)
        u_acc = [];
        assignin('base', 'u_control', u_acc);
    end
    
    if(isempty(s_acc) || t == dt)
        s_acc = [];
        assignin('base', 'sliding_s', s_acc);
    end
    % ----------------------------------------------------------------- %
    
    q_p = x(1:m+n);
    
    z = [];
    
    % XXX: Deprecated for the moment
    if(is_int)
        z = x(m+n+1:end);
    
        if(is_dyn_bound)
            phi = x(m+n+2:end);
            
            for i = 1:length(phi)
                if(phi(i) < 0)
                    phi(i) = 0;
                end
            end
            
            if(isempty(phi0))
                phi0 = phi;
            end
        end
    else
        if(is_dyn_bound)
            phi = x(m+n+1:end);
            
            for i = 1:length(phi)
                if(phi(i) < 0)
                    phi(i) = 0;
                end
            end

            if(isempty(phi0))
                phi0 = phi;
            end
        end
    end
    
    % ----------------------------------------------------------------- %
    % Switching function
    if(strcmp(u_struct.switch_type, 'sat'))
        if(is_dyn_bound)
            switch_func = @(s) sat_sign(s, phi);
        else
            switch_func = @(s) sat_sign(s, u_struct.phi0);
        end
    elseif(strcmp(u_struct.switch_type, 'hyst'))
        if(is_dyn_bound)
            switch_func = @(s) hyst_sign(s, -phi, phi);
        else
            switch_func = @(s) hyst_sign(s, u_struct.phi_min, ...
                                         u_struct.phi_max);
        end
    elseif(strcmp(u_struct.switch_type, 'sign'))
        switch_func = @(s) sign(s);
    elseif(strcmp(u_struct.switch_type, 'poly'))
        if(is_dyn_bound)
            switch_func = @(s) poly_sat(s, phi, u_struct.degree);
        else
            switch_func = @(s) poly_sat(s, u_struct.phi0, u_struct.degree);
        end
    else
        error('The options are sat, hyst, sign or poly.');
    end
    % ----------------------------------------------------------------- %
    
    % States and velocities
    q = sys.kin.q;
    p = sys.kin.p{end};
    pp = sys.kin.pp{end};
    
    C = sys.kin.C;    
    Cp = sys.kin.Cp;
    
    q_p_s = [q; C*p];
    
    q_d = add_symsuffix(q, '_d');
    p_d = add_symsuffix(p, '_d');
    pp_d = add_symsuffix(pp, '_d');
    
    Ms_struct = u_struct.Ms_struct;
    Fs_struct = u_struct.Fs_struct;
    cparams = u_struct.cparams;
    
    Ms_hat = Ms_struct.Ms_hat;
    fs_hat = Fs_struct.fs_hat;
    sr_p = cparams.sr_p;
    
    % Symbolics
    q_p_s = [q; p];
    q_p_pp = [q; p; pp];
    q_p_pp_d = [q_d; p_d; pp_d];
    
    % Nummerical
    symbs =  u_struct.cparams.symvars;
    params = double([q_p; z; q_p_ref_fun(t)]);

    % ----------------------------------------------------------------- %
    
    % Gain
    K = u_struct.K(Fs_struct, Ms_struct);
    K = subs(K, symbs, params);
    
    % Control law
    switched_sn = zeros(m, 1);
    s_n = subs(cparams.s, symbs, params);
    
    for i = 1:m
        switched_sn(i) = double(switch_func(s_n(i)));
    end
    
    varargout{1} = [];
    varargout{2} = [];
    
    k = diag(K);
    
    % Integrative portion
    if(u_struct.is_int)
        varargout{2} = subs([varargout{2}; ...
                             u_struct.cparams.int_q], ...
                             symbs, params);                    
    end
    
    if(is_dyn_bound)
        m = length(k);

        phi = double(phi);
        s_n = double(s_n);
        
        if((s_n <= phi)&&(s_n >= -phi))
            one_vec = ones(m, 1);
            dz = zeros(m, 1);
            
            perc_phi = 1e-1;
            delta_0 = 1e-2;
            delta_phi = 1e-2;
            delta_s = 1e-1;

            if(isempty(curr_s_sign))
                curr_s_sign = sign(s_n);
            end

            if(isempty(t_curr))
                t_curr = t;
            end

            for i = 1:m
                step_i = switched_sn(i);

                k_i = k(i);
                s_i = s_n(i);
                step_lim = switch_func(s_n(i));

                abs_eps = abs(step_i);
                L_i = (1 - abs_eps)/(1 + abs_eps) - delta_s/k_i;
                scaler_i = (abs_eps + L_i)/(abs_eps + 1);
                
                if(phi(i) > 0)
                    scaler_sign = -1;
                else
                    scaler_sign = 1;
                end

                dz(i) = scaler_sign*scaler_i*k_i;
                
                if(phi(i) < perc_phi*phi0)
                    dz = 0;                
                end
            end

            if(~strcmp('sign', u_struct.switch_type))
                k = k - dz;
            end

        else
            zeros_vec = zeros(m, 1);
            dz = zeros_vec;
        end

        varargout{2} = [varargout{2}; dz];
    end
    
    K = diag(k);
    
    u_sym = -inv(Ms_hat)*(fs_hat + sr_p + K*switched_sn);
    u_sym = inv(u_struct.V.')*u_sym;
    
    params_symbs = sys.descrip.syms;
    params_vals = sys.descrip.model_params;    
    u_sym = subs(u_sym, params_symbs, params_vals);
    
    u = subs(u_sym, symbs, params);
    
    varargout{1} = u;
    
    counter = counter + 1;
    if(counter == 1)
        u_acc = [u_acc; u'];
        s_acc = [s_acc; s_n']; 
        k_gains = [k_gains; k']; 

        assignin('base', 'u_control', u_acc);
        assignin('base', 'sliding_s', s_acc);
        assignin('base', 'k_gains', k_gains);
    end
    
    % XXX: Typically one uses Runge kutta of 5th order,
    % which has 8 steps
    n_ode = 8;
    if(counter == n_ode)
        counter = 0;
    end
end

