function sol = validate_model(sys, t, x0, u_func)
    [n, m] = size(sys.kin.C);
    
    if(length(x0) ~= n + m)
        error('Initial values MUST have the same length as states!')
    end
    
    % Waitbar for the simulation
    wb = my_waitbar('Mechanical system - Simulation');
    
    df_ = @(t_, q_p) df(t_, q_p, sys, t(end), u_func, wb);
    cancel_sim = @(t, q_p) cancel_simulation(t, q_p, wb);
    
    % Mass matrix
    sol = my_ode45(df_, t, x0);
    
    wb = evalin('base', 'wb');
    wb.close_window();
end

function [value, is_terminal, direction] = cancel_simulation(t, q_p, wb)
    h = wb.find_handle();
    h = h(1);
    value = getappdata(h,'canceling');
    is_terminal = 1;
    direction = 0;
end

function dq = df(t, q_p, sys, tf, u_func, wb)
    persistent wb_;
    
    if(isempty(wb_))
        wb_ = wb;
    end
    
    [n, m] = size(sys.kin.C);
    t0 = tic;
    
    symbs = sys.descrip.syms;
    m_params = sys.descrip.model_params;
    
    C_num = subs(sys.kin.C, symbs, m_params);
    H_num = subs(sys.dyn.H, symbs, m_params);
    h_num = subs(sys.dyn.h, symbs, m_params);
    Z_num = subs(sys.dyn.Z, symbs, m_params);

    if(iscell(sys.kin.p))
        p = sys.kin.p{end};
    else
        p = sys.kin.p;
    end
    
    q_num = q_p(1:n);
    p_num = q_p(n+1:end);
    
    qp_s = [sys.kin.q; p];
    qp_n = [q_num; p_num];
    
    C_num = subs(C_num, qp_s, qp_n);
    H_num = subs(H_num, qp_s, qp_n);
    h_num = subs(h_num, qp_s, qp_n);
    Z_num = subs(Z_num, qp_s, qp_n);
            
    Hinv = double(H_num\eye(m));

    dq = double([C_num*p_num; Hinv*(-h_num + Z_num*u_func(t, q_p))]);    
    
    % Time elapsed
    dt = toc(t0);
    
    wb_ = wb_.update_waitbar(t, tf);
    assignin('base', 'wb', wb_)
end

