function sol = simulate_sys(sys, t, x0)
    tf = t(end);
    wb = waitbar(0,'1','Name','Calculating trajectory...',...
                'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

    setappdata(wb,'canceling',0);
    
    df_ = @(t, q) df(t, q, sys, wb, tf);
    opts = odeset('RelTol',1e-7, 'AbsTol',1e-7);
    sol = ode45(df_, t, x0, opts);
end

function dq = df(t, q_p_num, sys, wb, tf)
    persistent canceled_pressed;
    
    if isempty(canceled_pressed)
        canceled_pressed = false;
    end

    
    % Update waitbar and message
    msg = sprintf('%3.3f',100*t/tf);
    waitbar(t/tf, wb, msg);

    dq_sym = subs(sys.dyn.f_subs, sys.syms, sys.model_params);
    dq_sym = vpa(dq_sym);
    
    q_p_sym = [sys.q; sys.p];
    dq_ = vpa(subs(dq_sym, q_p_sym, q_p_num));
    
    dq = double(dq_);
    
    % Check for clicked Cancel button
    if getappdata(wb,'canceling') || canceled_pressed
        canceled_pressed = true;
        
        close(wb);
        dq = zeros(size(dq));
        return;
    end
end