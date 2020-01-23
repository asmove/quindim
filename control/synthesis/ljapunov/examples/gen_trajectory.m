function [xhat_traj, xphat_traj, xpphat_traj, ...
          phat_traj, pphat_traj] = gen_trajectory(t, points, traj_fun)
    persistent counter phat_t xhat_t pphat_t xphat_t;
    
    [xhat_traj, xphat_traj, xpphat_traj, ...
     phat_traj, pphat_traj] = traj_fun(t, points, dt);
    
                            
    phat_t = [phat_t; phat_traj'];
    xhat_t = [xhat_t; xhat_traj'];
    pphat_t = [pphat_t; pphat_traj'];
    xphat_t = [xphat_t; xphat_traj'];

    assignin('base', 'xhat_t', xhat_t);
    assignin('base', 'phat_t', phat_t);
    assignin('base', 'xphat_t', xphat_t);
    assignin('base', 'pphat_t', pphat_t);
end