function dq = plant_fun(t, q_p, sys, input_func, V)
    persistent C_params H_params h_params Z_params invH_params ...
               counter us;
    t0 = tic;
    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(us))
        us = [];
    end
    toc(t0);
    
    symbs = sys.descrip.syms;
    m_params = sys.descrip.model_params;
    
    if(isempty(C_params))
        C_params = subs(sys.kin.C, symbs, m_params);
        H_params = subs(sys.dyn.H, symbs, m_params);
        invH_params = inv(H_params);
        h_params = subs(sys.dyn.h, symbs, m_params);
        Z_params = subs(sys.dyn.Z, symbs, m_params);
    end
    
    % Linearizing input
    n_q = length(sys.kin.q);
    n_p = length(sys.kin.p{end});
    
    w = input_func(t, q_p);
    t0 = tic;
    q_num = q_p(1:n_q);
    p_num = q_p(n_q+1:n_q+n_p);
    q_p_z = q_p;
    q_p = q_p_z(1:end-1);
    z_1 = q_p_z(end);
    toc(t0);
    
    t0 = tic;
    q = sys.kin.q;
    p = sys.kin.p{end};
    
    C_pars = subs(C_params, q, q_num);
    toc(t0);
    
    t0 = tic;
    v = V*[z_1; w(2)];
    x_syms = sym('x_', [7, 1]);
    
    symbs = [q; p; x_syms; symbs.'];
    vals = [q_num; p_num; q_p_z; m_params.'];
    u_ = subs(inv(Z_params)*(H_params*v + h_params), symbs, vals);    
    toc(t0);
    u_
    t0 = tic;
    dq = vpa(subs([C_pars*p_num; ...
               invH_params*(-h_params + Z_params*u_); ...
               w(1)], symbs, vals));
    
    counter = counter + 1;
    if(counter == 1)
        us = [us; u_'];
        assignin('base', 'input_torque', us);
    end
    toc(t0);
    if(counter == 4)
        counter = 0;
    end
end
