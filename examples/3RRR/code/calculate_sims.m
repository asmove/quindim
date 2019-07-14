function sims = calculate_sims(mechanism, trajectory)
    [is_valid, ...
     is_wss, ...
     is_sings] = validate_trajectory(mechanism, trajectory);

    if(is_valid)
        n = length(trajectory.t);
    
        % Begin of simulation
        sim = struct('');
        prev_sim = sim;

        f = waitbar(0,'1','Name','Calculating trajectory...',...
                    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

        setappdata(f,'canceling',0);

        % Offline calculation of simulation parameters
        sims = {};
        for i = 1:n
            % Check for clicked Cancel button
            if getappdata(f,'canceling')
                break
            end

            sim = update_sim(i, prev_sim, mechanism, trajectory);
            sims{i} = sim;

            % Update waitbar and message
            waitbar(i/n,f,sprintf('%3.3f',100*i/n))

            prev_sim = sim;
        end
    else
        idx_ws = find(is_wss == 0);
        idx_s = find(is_sings == 0);
        
        disp('The following points are out from WS:');
        trajectory.q(idx_ws, :)
        
        disp('The following points are singularities:');
        trajectory.q(idx_s, :)
        
        error('Trajectory not valid: out of workspace or singularity');
    end
    
end