function varargout = output_sliding(t, x, q_p_ref_fun, u_struct, ...
                            sys, tf, dt, is_dyn_bound)
    persistent u_acc s_acc s_0 counter k_gains;
    
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
    
    if(is_dyn_bound)
        q_p = x(1:end-m);
        phi = abs(x(end-m+1:end));
        
    else
        q_p = x(1:end);
    end
    
    % Control output
    if(strcmp(u_struct.switch_type, 'sat'))
        if(is_dyn_bound)
            switch_func = @(s) sat_sign(s, phi);
        else
            switch_func = @(s) sat_sign(s, u_struct.phi);
        end
    elseif(strcmp(u_struct.switch_type, 'hyst'))
        switch_func = @(s) hyst_sign(s, ...
                                     u_struct.phi_min, ...
                                     u_struct.phi_max);
    elseif(strcmp(u_struct.switch_type, 'sign'))
        switch_func = @(s) sign(s);
    elseif(strcmp(u_struct.switch_type, 'poly'))
        if(is_dyn_bound)
            switch_func = @(s) poly_sat(s, phi, u_struct.degree);
        else
            switch_func = @(s) poly_sat(s, u.phi, u_struct.degree);
        end
    else
        error('The options are sat, hyst, sign or poly.');
    end
    
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
    
    Ms_hat = Ms_struct.Ms_hat;
    fs_hat = Fs_struct.fs_hat;
    sr_p = u_struct.sr_p;
    
    % Symbolics
    q_p_s = [q; p];
    q_p_pp = [q; p; pp];
    q_p_pp_d = [q_d; p_d; pp_d];
    
    symbs =  [q_p_s; q_p_pp_d];
    
    % Nummerical
    params = double([q_p; q_p_ref_fun(t)]);
    
    % Gain
    K = u_struct.K(Fs_struct, Ms_struct);
    K = subs(K, symbs, params);
    
    % Control law
    switched_sn = zeros(m, 1);
    s_n = subs(u_struct.s, symbs, params);
    
    for i = 1:m
        switched_sn(i) = double(switch_func(s_n(i)));
    end
    
    if(t == dt)
       s_0 = s_n; 
    end
    
    u_sym = -inv(Ms_hat)*(fs_hat + sr_p + K*switched_sn);
    u_sym = inv(u_struct.V.')*u_sym;
    
    symbs = sys.descrip.syms;
    params = sys.descrip.model_params;
    
    u_sym = subs(u_sym, symbs, params);
    
    symbs =  [q_p_s; q_p_pp_d];
    params = double([q_p; q_p_ref_fun(t)]);
    
    u = subs(u_sym, symbs, params);
    k = diag(K);
    
    % dphi
    if(is_dyn_bound)
        if((s_n <= phi)&&(s_n >= -phi))
            EPS = 1e-4;
            one_vec = ones(length(k), 1);
            if(s_n > 0)
                dz = -K*switched_sn + EPS*one_vec;
            else
                dz = -K*switched_sn - EPS*one_vec;
            end
        else
            zeros_vec = zeros(length(k), 1);
            dz = zeros_vec;
        end

        varargout{1} = dz;
        varargout{2} = u;
    else
        varargout{1} = u;
    end
    
    counter = counter + 1;
    if(counter == 1)
        u_acc = [u_acc; u'];
        s_acc = [s_acc; s_n']; 
        k_gains = [k_gains; k']; 

        assignin('base', 'u_control', u_acc);
        assignin('base', 'sliding_s', s_acc);
        assignin('base', 'k_gains', k_gains);
    end
    
    n_ode = 4;
    if(counter == n_ode)
        counter = 0;
    end
end

