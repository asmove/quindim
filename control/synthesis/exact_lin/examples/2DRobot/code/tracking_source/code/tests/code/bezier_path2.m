function traj = bezier_path2(t, T, A, B, ...
                           thetaA, alphaA, alphaB, ...
                           n_diffs)
    persistent t_trajs trajs counter;
    
    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(t_trajs))
        t_trajs = [];
    end
    
    if(isempty(trajs))
        trajs = [];
    end
    
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
    
    counter = counter + 1;
    if(counter == 1)
        t_trajs = [t_trajs; t];
        trajs = [trajs; P_t'];

        assignin('base', 't_trajs', t_trajs);
        assignin('base', 'trajs', trajs);
        end
    
    if(counter == 8)
        counter = 0;
    end
        
    for n_diff = 1:n_diffs
        dP_i = recursive_ndbezier(t, Ps, n_diff);
        traj = [traj; dP_i];
    end
end