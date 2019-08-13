function sol = validate_model(sys, t, x0, u0)
    t0 = tic;
    
    n = length(sys.kin.q);
    
    % Waitbar for the simulation
    wb = waitbar(0,'1',  ...
                 'Name','Calculating simulation',...
                 'CreateCancelBtn', ...
                 'setappdata(gcbf,''canceling'',1)');

    setappdata(wb,'canceling',0);
    
    df_ = @(t_, q_p) df(t_, q_p, sys, t(end), u0, wb);
    cancel_sim = @(t, q_p) cancel_simulation(t, q_p, wb);
    
    % Mass matrix
    H = subs(sys.dyn.H, [sys.descrip.syms], [sys.descrip.model_params]);
    
    qp = [sys.kin.q; sys.kin.p];
    
    opts = odeset('RelTol', 1e-7, 'AbsTol', 1e-7, 'Events', cancel_sim);
    
    sol = ode23t(df_, t, x0, opts);
    
    % Erase waitbar
    delete(wb);
    toc(t0);
end

function [value, is_terminal, direction] = cancel_simulation(t, q_p, wb)
    value = getappdata(wb,'canceling');
    is_terminal = 1;
    direction = 0;
end

function dq = df(t, q_p, sys, tf, u0, wb)
    t0 = tic;

    dq_p = subs(sys.dyn.f, sys.descrip.syms, sys.descrip.model_params);
            
    dq = double(vpa(subs(dq_p, ...
                         [sys.descrip.u; sys.kin.q; sys.kin.p], ...
                         [u0; q_p])));
                     
    % Time elapsed
    dt = toc(t0);
    
    % Time structure
    time_params.tf = tf;
    time_params.dt = dt;
    time_params.t = t;

    update_waitbar(wb, time_params)
end

function update_waitbar(wb, time_params)
    persistent speed_acc;
    persistent t_acc;
    persistent tf_acc;
    persistent tr_acc;
    
    if isempty(speed_acc)
        t_acc = 0;
        tf_acc = [];
        speed_acc = [];
        t_elapsed=[];
    end

    % Time unwrapping
    tf = time_params.tf;
    dt = time_params.dt;
    t = time_params.t;
    
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
        t_f = 100/speed;
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
