function combs_k = comb_vec(a, b)
    combs = combvec(a, b);

    [m, n] = size(combs);

    combs_c = {};
    for i = 1:n
        combs_c{end+1} = combs(:, i);
    end
    
    % Waitbar for the simulation
    wb = waitbar(0,'1',  ...
                 'Name','Calculating simulation',...
                 'CreateCancelBtn', ...
                 'setappdata(gcbf,''canceling'',1)');
    
    set(findall(wb,'type','text'),'Interpreter','none');
    
    t_acc = 0;
    tf_acc = [];
    speed_acc = [];
    t_elapsed=[];
    
    combs_k = {};
    for k = 1:n-1
        t0 = tic;
        
        combs_k{end+1} = combntns(combs_c, k);
        
        % Time elapsed
        dt = toc(t0);
        
        % Variable updates - Time, percentage, display current time, 
        % display end time, average speed
        t_acc = t_acc + dt;

        perc = 100*k/n;
        t_curr = datestr(seconds(t_acc), 'HH:MM:SS');
        speed = perc/t_acc;
        
        if((perc < eps)||(speed < eps))
            t_f = 0;
            tf_acc = [tf_acc, t_f];
            
            msg = sprintf('%d - %.1f [%%/s] [%s]', ...
                          perc, speed, t_curr);
        else
            t_f = 100/speed;
            tf_acc = [tf_acc, t_f];
            
            horizon = 5;
            if(length(tf_acc) < horizon + 1)
                tf_ = tf_acc(end);
            else
                tf_ = tf_acc(end-horizon:end);
            end
            t_end = datestr(seconds(mean(tf_)), 'HH:MM:SS');
            msg = sprintf('%3.0f %% - %.1f [%%/s] [%s - %s]', ...
                      perc, speed, t_curr, t_end); 
        end
        
        waitbar(k/n, wb, msg);
    end
end