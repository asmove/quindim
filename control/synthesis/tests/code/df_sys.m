function dx = df_sys(t, x, q_p_d, u_struct, sys, tf)
    persistent t_1;
    persistent dt;
    persistent wb;
    
    [n, m] = size(sys.dyn.Z);
    
    if(isempty(dt) && isempty(t_1) && isempty(wb))
        t_1 = t;
        dt = 0;
        wb = my_waitbar('Simulate underactuated');
    end

    q_p = x(1:end);
    q_p_s = [sys.kin.q; sys.kin.p];
    q_p_d_s = add_symsuffix([q_p_s; sys.kin.pp], '_d');
    
    eta = u_struct.eta;
    
    sr_p = double(subs(u_struct.sr_p, [q_p_s; q_p_d_s], [q_p; q_p_d]));
    fs_hat = double(subs(u_struct.fs_hat, [q_p_s; q_p_d_s], [q_p; q_p_d]));
    K = double(subs(u_struct.K, [q_p_s; q_p_d_s], [q_p; q_p_d]));
    Ms_hat = double(subs(u_struct.Ms_hat, [q_p_s; q_p_d_s], [q_p; q_p_d]));
    
    alpha_ = u_struct.alpha;
    lambda = u_struct.lambda;

    G = [alpha_, lambda];
    
    error = q_p - q_p_d(1:end-n);
    s = G*error;
    
    u = -inv(Ms_hat)*(sr_p + fs_hat + K*sign(s));
    
    plant = subs(sys.dyn.plant, sys.descrip.syms, ...
                 sys.descrip.model_params);
    plant = subs(plant, sys.descrip.u, u);
    
    dx = double(subs(plant, q_p_s, q_p));
    
    wb.update_waitbar(t, tf);
    
    dt = t - t_1;
    t_1 = t;
end