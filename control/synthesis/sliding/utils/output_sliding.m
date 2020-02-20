function u = output_sliding(t, x, q_p_ref_fun, u_struct, sys, tf)
    persistent t_1 dt u_acc s_acc switch_func;
    
    [n, m] = size(sys.dyn.Z);
    
    if(isempty(dt) && isempty(t_1))
        t_1 = t;
        dt = 0;
        u_acc = [];
    end
    
    if(t == 0)
       s_acc = [];
       u_acc = [];
    end
    
    if(isempty(switch_func))
        % Control output
        if(strcmp(u_struct.switch_type, 'sat'))
            switch_func = @(s) sat_sign(s, u_struct.phi);
        elseif(strcmp(u_struct.switch_type, 'hyst'))
            switch_func = @(s) hyst_sign(s, ...
                                         u_struct.phi_min, ...
                                         u_struct.phi_max);
        elseif(strcmp(u_struct.switch_type, 'sign'))
            switch_func = @(s) sign(s);
        else
            error('The options are sat, hyst and sign.');
        end
    end
    
    % States and velocities
    q = sys.kin.q;
    p = sys.kin.p{end};
    pp = sys.kin.pp{end};
    
    C = sys.kin.C;    
    Cp = sys.kin.Cp;
    
    q_p = x(1:end);
    q_p_s = [q; C*p];
    
    q_d = add_symsuffix(q, '_d');
    p_d = add_symsuffix(p, '_d');
    pp_d = add_symsuffix(pp, '_d');
    
    q_p_s = [q; p];
    q_p_pp = [q; p; pp];
    q_p_pp_d = [q_d; p_d; pp_d];
    
    symbs = [q_p_s; q_p_pp_d];
    nums = [q_p; q_p_ref_fun(t)];
    
    s_n = subs(u_struct.s, symbs, nums);
    
    switched_sn = zeros(m, 1);
    
    for i = 1:m
        switched_sn(i) = switch_func(s_n(i));
    end
    
    Ms_hat = u_struct.Ms_hat;
    fs_hat_n = u_struct.fs_hat_n;
    sr_p = u_struct.sr_p;
    K = u_struct.K;
    u = subs(-inv(u_struct.Ms_hat)*...
             (u_struct.fs_hat_n + u_struct.sr_p + ...
             u_struct.K*switched_sn), symbs, nums);

    u = inv(u_struct.V.')*u;
    
    Hinv = sys.dyn.H\eye(length(sys.dyn.H));
    
    symbs = sys.descrip.syms;
    model_params = sys.descrip.model_params;
    Z = sys.dyn.Z;
    u_sym = sys.descrip.u;
    h = sys.dyn.h;
    
     plant = [C*p; ...
             -sys.dyn.H\sys.dyn.h + sys.dyn.H\sys.dyn.Z*sys.descrip.u];
    plant = subs(plant, sys.descrip.syms, sys.descrip.model_params);
    plant = subs(plant, sys.descrip.u, u);
    
%     plant = [C*p; Hinv*(-h + Z*u)];
%     plant = subs(plant, symbs, model_params);
    plant = subs(plant, u_sym, u);
    
    u_acc = [u_acc; u'];
    s_acc = [s_acc; s_n'];
    
    assignin('base', 'u_control', u_acc);
    assignin('base', 'sliding_s', s_acc);
end

