function dx_ds = df_sys(t, x, q_p_d, u_struct, sys, tf)
    persistent wb;
    
    if(isempty(wb))
        wb = my_waitbar('Simulate underactuated');
    end

    q_p = x(1:end-1);
    s = x(end);
    q_p_s = [sys.kin.q; sys.kin.p];
    q_p_d_s = add_symsuffix([q_p_s; sys.kin.pp], '_d');
    
    eta = u_struct.eta;
    tic
    sr_p = subs(u_struct.sr_p,  [q_p_s; q_p_d_s], [q_p; q_p_d]);
    toc
    tic
    fhat = subs(u_struct.fs_hat,  q_p_s, q_p);
    toc
    tic
    Ms_hat = subs(u_struct.Ms_hat,  q_p_s, q_p);
    toc
    tic
    K = subs(u_struct.K,  q_p_s, q_p);
    toc
    u = -inv(Ms_hat)*(sr_p + fhat + K*sign(s));
    
    tic
    plant = sys.dyn.f + sys.dyn.G*sys.descrip.u;
    plant = subs(plant, sys.descrip.syms, sys.descrip.model_params);
    plant = subs(plant, q_p_s, q_p);
    plant = subs(plant, sys.descrip.u, u);
    toc
    
    ds = -eta*sign(s);
    dx = plant;
    
    dx_ds = double([dx; ds]);
    
    wb.update_waitbar(t, tf); 
end