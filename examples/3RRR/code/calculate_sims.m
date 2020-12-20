function sims = calculate_sims(mechanism, trajectory, is_to_validate)
    if(is_to_validate)
        [is_valid, ...
         is_wss, ...
         is_sings] = validate_trajectory(mechanism, trajectory);
    else
        is_valid = true;
        is_wss = [];
        is_sings = [];
    end
     
    if(is_valid)
        n = length(trajectory.t);
    
        % Begin of simulation
        sim = struct('');
        prev_sim = sim;

        wb = my_waitbar('Calculation of inner angles');
        
        % Offline calculation of simulation parameters
        sims = {};
        for i = 1:n
            sim = update_sim(i, prev_sim, mechanism, trajectory);
            sims{i} = sim;

            prev_sim = sim;
        
            wb.update_waitbar(i, n);
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
    
    wb = my_waitbar('Calculation of inner angles');
    
end