function [is_valid, is_wss, is_sings] = validate_trajectory(mechanism, trajectory)
    is_valid = true;
    is_wss = [];
    is_sings = [];
    
    n = length(mechanism.eqdyn.q_bullet);
    
    for i = 1:length(trajectory.t)
        q_bullet = trajectory.q(i, :).';
        [q_circ_, is_ws] = q_circ(mechanism, zeros(n, 1), q_bullet);
        q = [q_bullet; q_circ_];
        is_sing = is_singularity(mechanism, q);
        
        if(is_ws)
            if(is_sing)
                is_valid = false;
            end
        else
            is_valid = false;
        end
        
        is_wss = [is_wss; is_ws];
        is_sings = [is_sings; is_sing];
    end
end