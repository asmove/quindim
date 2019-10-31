function sol = validate_model(sys, t, x0, u0)
    n = length(sys.kin.q);
    
    % Waitbar for the simulation
    wb = my_waitbar('Mechanical system - Simulation');
    
    df_ = @(t_, q_p) df(t_, q_p, sys, t(end), u0, wb);
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

function dq = df(t, q_p, sys, tf, u0, wb)
    persistent wb_;
    
    if(isempty(wb_))
        wb_ = wb;
    end

    t0 = tic;
    
    dq_p = subs(sys.dyn.f, sys.descrip.syms, sys.descrip.model_params);
    dq_p = subs(sys.dyn.f, sys.descrip.syms, sys.descrip.model_params);
    
    if(iscell(sys.kin.p))
        p = sys.kin.p{end};
    else
        p = sys.kin.p;
    end
    
    qp = [sys.kin.q; p];
    uq_s = [sys.descrip.u; qp];
    uq_n = [u0; q_p];
    
    % Quick hack: double subs
    dq = subs(dq_p, uq_s, uq_n);

    dq = double(vpa(dq));
    
    % Time elapsed
    dt = toc(t0);
    
    wb_ = wb_.update_waitbar(t, tf);
    assignin('base', 'wb', wb_)
end

