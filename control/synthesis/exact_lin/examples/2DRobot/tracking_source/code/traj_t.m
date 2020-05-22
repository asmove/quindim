function traj = traj_t(t, T, P0, P1, theta0, traj_type, sys)
    persistent traj_params P0_prev;
    
    P0 = double(P0);
    P1 = double(P1);
    
    syms t_;
    
    EPS_ = 1e-5;
    if(isempty(traj_params)||(norm(P0_prev - P0) > EPS_))
        switch traj_type
            case 'line'
                % Do nothing
                
            case 'bezier'
                alphaA = 0.3;
                alphaB = 0.3;
                
                P0_prev = P0;
                
                traj_params.xy_t = bezier_path(t_, T, P0, P1, theta0, alphaA, alphaB);
                traj_params.xy_t = vpa(expand(traj_params.xy_t));
                
            case 'polynomial'
                P0_prev = P0;
                traj_params.xy_t = traj_exppoly(P0, P1, theta0, T, 'polynomial', sys);
                
            case 'exp'
                P0_prev = P0;
                traj_params.xy_t = traj_exppoly(P0, P1, theta0, T, 'exp', sys);
                
            case 'circle_line'
                P0_prev = P0;
                traj_params = struct('');
                
                v = norm(P1 - P0)/T;

                v_0 = v;
                v_01 = v; 
                v_1 = v;

                % Percentage under AB distance
                alpha_0 = 0.2;
                alpha_1 = 0.2;
                
                traj_params = traj_tangentAB(P0, P1, theta0, ...
                                             v_0, v_01, v_1, ...
                                             alpha_0, alpha_1);
                
                traj_params = traj_params{1};
                
%                 % TAKE NOTE: Sum MUST be lesser than 1
%                 alpha_0_ = 0.25;
%                 alpha_01_ = 0.5;
%                 alpha_1_ = 0.25;

                % Geometrical properties
                arg0 = traj_params.arg0;
                dCD = traj_params.dCD;
                arg1 = traj_params.arg1;
                
                r0 = traj_params.r0;
                r1 = traj_params.r1;

%                 v_0 = arg0*r0/(alpha_0_*T);
%                 v_01 = dCD/(alpha_01_*T);
%                 v_1 = arg1*r1/(alpha_1_*T);

                v = (r0*arg0 + dCD + r1*arg1)/T;
                v_0 = v;
                v_01 = v;
                v_1 = v;

                t_0 = traj_params.t_0;
                t_01 = traj_params.t_01;
                t_1 = traj_params.t_1;
                
                traj_params = traj_tangentAB(P0, P1, theta0, v_0, v_01, v_1, alpha_0, alpha_1);
                traj_params = traj_params{1};
        end
    end
    
    switch traj_type
        % Line trajectory
        case 'line'
            traj = [P0 + (t/T)*(P1 - P0); ...
                    (P1 - P0)/T; ...
                    zeros(P0); ...
                    zeros(P0)];
            
        % Bezier curve
        case 'bezier'
            % Exponential and polynomial curves
            xy_t = traj_params.xy_t;
            dxy_t = diff(traj_params.xy_t, t_);
            d2xy_t = diff(dxy_t, t_);
            d3xy_t = diff(d2xy_t, t_);

            traj = subs([xy_t; dxy_t; d2xy_t; d3xy_t], t_, t);
                                      
        case 'polynomial'
            % Exponential and polynomial curves
            xy_t = traj_params.xy_t;
            dxy_t = diff(traj_params.xy_t, t_);
            d2xy_t = diff(dxy_t, t_);
            d3xy_t = diff(d2xy_t, t_);

            traj = subs([xy_t; dxy_t; d2xy_t; d3xy_t], t_, t);
            
        case 'exp'
            % Exponential and polynomial curves
            xy_t = traj_params.xy_t;
            dxy_t = diff(traj_params.xy_t, t_);
            d2xy_t = diff(dxy_t, t_);
            d3xy_t = diff(d2xy_t, t_);

            traj = subs([xy_t; dxy_t; d2xy_t; d3xy_t], t_, t);
            
        case 'circle_line'
            % Time and trajectory vector 
            t_traj1 = traj_params.t_traj{1};
            t_traj2 = traj_params.t_traj{2};
            t_traj3 = traj_params.t_traj{3};
            
            t_traj = double([t_traj1; t_traj2; t_traj3]);

            traj1 = traj_params.trajectory{1};
            traj2 = traj_params.trajectory{2};
            traj3 = traj_params.trajectory{3};
            traj = double([traj1; traj2; traj3]);
            t = double(t);
            
            xy_t = interp1(t_traj, traj, t)';
            dxy_t = traj_params.traj_diff(t, 1);
            d2xy_t = traj_params.traj_diff(t, 2);
            d3xy_t = traj_params.traj_diff(t, 3);
            
            traj = [xy_t; dxy_t; d2xy_t; d3xy_t];
        otherwise
            error('Trajectory type must be either line, bezier, polynomial, exp or circle_line!');
    end
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
    [params_syms, params_sols, params_model] = ...
     gentrajmodel_2Drobot(sys, traj_type, T, points_);

    params_sols = double(params_sols);

    xy_t = subs(params_model, ...
                [params_syms; T; sym('t')], ...
                [params_sols; T_; t_]);
end