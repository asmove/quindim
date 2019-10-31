function dx = df_sys(t, x, q_p_ref_fun, u_struct, sys, tf)
    persistent t_1;
    persistent dt;
    persistent wb;
    persistent u_acc;
    persistent s_acc;
    
    [n, m] = size(sys.dyn.Z);
    
    if((isempty(dt) && isempty(t_1) && isempty(wb)) ||...
        (~isgraphics(wb.wb)))
        t_1 = t;
        dt = 0;
        wb = my_waitbar('Simulate underactuated');
        u_acc = [];
    end
    
    if(t == 0)
       s_acc = [];
       u_acc = [];
    end
    
    % States and velocities
    q = sys.kin.q;
    
    p = sys.kin.p{end};
    pp = sys.kin.pp{end};
    
    if((length(sys.kin.C) ~= 1) && (iscell(sys.kin.p)))
        [m, ~] = size(sys.kin.C{1});
        
        C = eye(m);
        for i = 1:length(sys.kin.C)
            C = C*sys.kin.C{i};
        end
    else
        C = sys.kin.C{end};
    end
    
    Cp = sys.kin.Cp;
    
    q_p = x(1:end);
    q_p_s = [q; C*p];
    
    q_d = add_symsuffix(q, '_d');
    p_d = add_symsuffix(p, '_d');
    pp_d = add_symsuffix(pp, '_d');
    
    q_p_s = [q; p];
    q_p_pp = [q; p; pp];
    q_p_pp_d = [q_d; p_d; pp_d];
    
    % Control output
    if(u_struct.is_sat)
        phi = evalin('base', 'phi');
        switch_func = @(s) sat_sign(s, phi);
    else
        switch_func = @(s) sign(s);
    end
    
    symbs = [q_p_s; q_p_pp_d];
    nums = [q_p; q_p_ref_fun(t)];
    
    s_n = subs(u_struct.s, symbs, nums);
    
    u = subs(-inv(u_struct.Ms_hat)*(u_struct.fs_hat_n + u_struct.sr_p + ...
                                    u_struct.K*switch_func(s_n)), ...
                                    symbs, nums);

    u = inv(u_struct.V.')*u;
    u
    plant = subs(sys.dyn.plant, ...
                 sys.descrip.syms, sys.descrip.model_params);
    
    plant = subs(plant, sys.descrip.u, u);
    
    u_acc = [u_acc; u'];
    
    dx = double(subs(plant, q_p_s, q_p));
    
    u_acc = [u_acc; u];
    s_acc = [s_acc; s_n];
    
    assignin('base', 'u_control', u_acc);
    assignin('base', 'sliding_s', s_acc);
    assignin('base', 'wb', wb);
    
    wb = wb.update_waitbar(t, tf);
    
    dt = t - t_1;
    t_1 = t;
end
