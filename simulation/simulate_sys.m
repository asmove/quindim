function sol = simulate_sys(sys, t, x0)
    tf = t(end);
    wb = waitbar(0,'1',  ...
                 'Name','Calculating simulation',...
                 'CreateCancelBtn', ...
                 'setappdata(gcbf,''canceling'',1)');

    setappdata(wb,'canceling',0);
    
    df_ = @(t, q) df(t, q, sys, wb, tf);
    opts = odeset('RelTol', 1e-7, 'AbsTol', 1e-7);
    sol = ode45(df_, t, x0, opts);
    close(wb);
end

function dq = df(t, q_p_num, sys, wb, tf)
    persistent canceled_pressed;
    persistent speed_acc;
    persistent t_acc;
    persistent tr_acc;
    persistent tf_acc;
    
    t0 = tic;
    
    if isempty(canceled_pressed)
        canceled_pressed = false;
        t_acc = 0;
        tf_acc = [];
        speed_acc = [];
        t_elapsed=[];
    end

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
    
    % Time elapsed
    dt = toc(t0);
    
    % Variable updates - Time, percentage, display current time, 
    % display end time, average speed
    t_acc = t_acc + dt;
    perc = 100*t/tf;
    t_curr = datestr(seconds(t_acc), 'HH:MM:SS');
    speed = perc/t_acc;

    tr_acc = [tr_acc, t_acc];    
    speed_acc = [speed_acc; speed];
    
    if(perc == 0)
        t_f = 0;
        msg = sprintf('%3.1f - %.1f [%%/s] [%s]', ...
                      perc, speed, t_curr);
    else
        t_f = 100/mean(speed_acc);
        t_end = datestr(seconds(mean(tf_acc)), 'HH:MM:SS');
        msg = sprintf('%3.1f - %.1f [%%/s] [%s - %s]', ...
                  perc, speed, t_curr, t_end); 
    end
    
    tf_acc = [tf_acc, t_f];
    assignin('base', 'tr_acc', tr_acc);
    assignin('base', 'tf_acc', tf_acc);
    assignin('base', 'speed_acc', speed_acc);
              
    waitbar(t/tf, wb, msg);
end