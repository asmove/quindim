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
    wb.idx
    q_p = x(1:end);
    q_p_s = [sys.kin.q; sys.kin.p];
    
    q_p_s = [sys.kin.q; sys.kin.p];
    q_p_d_s = add_symsuffix([q_p_s; sys.kin.pp], '_d');

    % Control output
    if(u_struct.is_sat)
       switch_func = @(s) sat_sign(s, 0.1);
    else
        switch_func = @(s) sign(s);
    end
    
    symbs = [q_p_s; q_p_d_s];
    nums = [q_p; q_p_d];
    
    s_n = subs(u_struct.s, symbs, nums);
    double(s_n)
    
    u = subs(-inv(u_struct.Ms_hat)*(u_struct.fs_hat_n + u_struct.sr_p + ...
                                    u_struct.K*switch_func(s_n)), symbs, nums);
    
    plant = subs(sys.dyn.plant, sys.descrip.syms, ...
                 sys.descrip.model_params);
    plant = subs(plant, sys.descrip.u, u);
    
    dx = double(subs(plant, q_p_s, q_p));
    
    wb.update_waitbar(t, tf);
    
    dt = t - t_1;
    t_1 = t;
end