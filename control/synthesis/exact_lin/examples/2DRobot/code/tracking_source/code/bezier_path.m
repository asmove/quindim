function traj = bezier_path(t, T, A, B, ...
                           thetaA, alphaA, alphaB, ...
                           n_diffs)
    persistent t_trajs trajs counter t_trajs_curr trajs_curr;
    persistent t_curr t_prev;
    
    AB = double(B - A);
    thetaB = cart2pol(AB(1), AB(2));

    % []
    r0 = [cos(thetaA); sin(thetaA)];
    r1 = [cos(thetaB); sin(thetaB)];

    C = A + r0*alphaA;
    D = B - r1*alphaB;

    Ps = {A, C, D, B};
    
    t = t/T;
    
    P_t = recursive_bezier(t, Ps);
    traj = P_t;
    
    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(t_curr))
        t_curr = t;
    end
    
    if(isempty(t_prev))
        t_prev = t;
    end
    
    if(isempty(t_trajs_curr))
        t_trajs = {};
        t_trajs_curr = [t_trajs_curr; t];
    end
    
    if(isempty(trajs_curr))
        trajs_curr = [trajs_curr; P_t];
    end
    
    if(isempty(trajs))
        trajs = {};
    end
    
    if(isempty(t_trajs))
        t_trajs = {};
    end
    
    t_prev = t_curr;
    t_curr = t;
    
    THRESHOLD = 0.9;
    t_curr = double(t_curr);
    
    if(t == 0)
        t_trajs{end+1} = t_trajs_curr;
        trajs{end+1} = trajs_curr;
        
        t_trajs_curr = [];
        trajs_curr = [];
        
        assignin('base', 't_trajs', t_trajs);
        assignin('base', 'trajs', trajs);
    end
    
    counter = counter + 1;
    if(counter == 1)
        t_trajs_curr = [t_trajs_curr; t];
        trajs_curr = [trajs_curr; P_t];
        size(trajs_curr)
    end
    
    if(counter == 8)
        counter = 0;
    end
        
    for n_diff = 1:n_diffs
        dP_i = recursive_ndbezier(t, Ps, n_diff);
        traj = [traj; dP_i];
    end
end