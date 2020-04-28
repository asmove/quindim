function traj = traj_t(t, T, P0, P1, theta0, traj_type, sys)
    syms t_;
    
    P0 = double(P0);
    P1 = double(P1);
    
    switch traj_type
        % Line trajectory
        case 'line'
            xy_t = P0 + (t_/T)*(P1 - P0);
        
        % Bezier curve
        case 'bezier'
            alphaA = 0.3;
            alphaB = 0.3;

            xy_t = vpa(expand(bezier_path(t_, T, ...
                                          P0, P1, theta0, ...
                                          alphaA, alphaB)));
        
        case 'polynomial'
            xy_t = traj_exppoly(P0, P1, theta0, T, 'polynomial', sys);
        
        case 'exp'
            xy_t = traj_exppoly(P0, P1, theta0, T, 'exp', sys);
            
        otherwise
            error('Trajectory type must be either line, bezier, polynomial or exp!');
    end

    % Exponential and polynomial curves
    dxy_t = diff(xy_t, t_);
    d2xy_t = diff(dxy_t, t_);
    d3xy_t = diff(d2xy_t, t_);
    
    traj = subs([xy_t; dxy_t; d2xy_t; d3xy_t], t_, t);
end

function xy_t = traj_exppoly(P0, P1, theta0, T_, traj_type, sys)
    syms t_ T;

    P10 = P1 - P0;
    
    thetaf = cart2pol(P10(1), P10(2));

    % Points to interpolate
    point0.t = 0;
    point0.coords = [P0; theta0];
    point1.t = T;
    point1.coords = [P1; thetaf];
    points_ = [point0; point1];

    % Coefficients generation
    [params_syms, ...
     params_sols, ...
     params_model] = ...
     gentrajmodel_2Drobot(sys, traj_type, T, points_);

    params_sols = double(params_sols);

    xy_t = subs(params_model, ...
                [params_syms; T; sym('t')], ...
                [params_sols; T_; t_]);
end