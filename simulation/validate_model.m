function xout = validate_model(sys, tspan, x0, u_func, is_dyn_control)
    if(nargin == 4)
        is_dyn_control = false;
    end
    
    [n, m] = size(sys.kin.C);
    
    odefun = @(t_, q_p) df(t_, q_p, sys, u_func, is_dyn_control);
    
    options.degree = 5;
    [t, xout] = ode('rk', odefun, x0, tspan, options);
    
    xout = double(xout);
end

function [value, is_terminal, direction] = cancel_simulation(t, q_p, wb)
    h = wb.find_handle();
    h = h(1);
    value = getappdata(h,'canceling');
    is_terminal = 1;
    direction = 0;
end

function dq = df(t, q_p, sys, u_function, is_dyn_control)
    [n, m] = size(sys.kin.C);
    
    t0 = tic;
    
    persistent C_params H_params h_params Z_params;

    symbs = sys.descrip.syms;
    m_params = sys.descrip.model_params;

    if(isempty(C_params))
        C_params = subs(sys.kin.C, symbs, m_params);
        H_params = subs(sys.dyn.H, symbs, m_params);
        h_params = subs(sys.dyn.h, symbs, m_params);
        Z_params = subs(sys.dyn.Z, symbs, m_params);
    end

    if(iscell(sys.kin.p))
        p = sys.kin.p{end};
    else
        p = sys.kin.p;
    end
    
    q_num = q_p(1:n);
    p_num = q_p(n+1:n+m);
    
    qp_s = [sys.kin.q; p];
    qp_n = [q_num; p_num];

    symbs = [symbs.'; qp_s];
    m_params = [m_params.'; qp_n];
    
    C_num = subs(C_params, symbs, m_params);
    H_num = subs(H_params, symbs, m_params);
    h_num = subs(h_params, symbs, m_params);
    Z_num = subs(Z_params, symbs, m_params);
    
    if(is_dyn_control)
        [u_num, dz_num] = u_function(t, q_p);
    else
        u_num = u_function(t, q_p);
    end
    
    Hinv = double(H_num\eye(m));
    
    speed = C_num*p_num;
    if(isempty(Z_num))
        accel = -Hinv*h_num;
    else
        accel = Hinv*(-h_num + Z_num*u_num);
    end
    
    if(is_dyn_control)
        dq = vpa([speed; accel; dz_num]);
    else
        dq = vpa([speed; accel]);
    end
    
    % Time elapsed
    dt = toc(t0);
end
