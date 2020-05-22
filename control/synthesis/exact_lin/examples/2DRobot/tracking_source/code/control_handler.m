function [u, dz] = control_handler(t, q_p, sestimation_info, ...
                                   trajectory_info, control_info, sys_)
    q_p = double(q_p);
    
    [xhat, save_states] = source_estimation(t, q_p, sestimation_info, sys_);    
    [u, dz] = run_control_law(t, q_p, xhat, sestimation_info, ...
                              trajectory_info, control_info, ...
                              sys_, save_states);
    if(isnan(u))
        error('Control law is not a number.')
    end
end
