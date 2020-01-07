function [coords, speeds] = trajectory_gen(points, dt, traj_model, ...
                                           traj2states_fun, freedom_syms, ...
                                           source_vars, q_s, qp_s, A, ...
                                           free_params, freedom_vals, ...
                                           T_val, model_syms, model_params)
    
    syms t T;
                                       
    % Symvars for source variables
    r = source_vars;
    drdt = dvecdt(r, q_s, qp_s);
    
    % Time dependent coordinates 
    r_t = traj_model;
    drdt_t = diff(r_t, t);
    d2rdt2_t = diff(drdt_t, t);

    constraints = A*qp_s;
    eqs_syms = [r - r_t; constraints];

    % TODO: Extend for more points. Currently only 2
    eqs = [];
    for i = 1:length(points)
        t_i = points(i).t;
        coords = points(i).coords;
        
        % States and freedom degree parameters
        symbs = [q_s; model_syms.'; drdt_t; freedom_syms];
        params = [coords; model_params.'; drdt_t; freedom_vals];
        eqs_i = subs(eqs_syms, model_syms, params);
        
        % Time substitution
        syms_t = [t; T; freedom_syms];
        vals_t = [t_i; T_val; freedom_vals];
        eqs_i = subs(eqs_i, syms_t, vals_t);

        eqs = [eqs; eqs_i];
    end
    
    eqs = subs(eqs, T, T_val);

    A1 = sys.kin.As{1};
    q = sys.kin.q;
    qp = sys.kin.qp;
    
    % Find rbar based in r
    rbar = q_s;
    for i = 1:length(r)
        coords_i = r(i);

        coords_idxs = find(rbar == coords_i);
        rbar(coords_idxs) = [];
    end
    
    % Find model parameters to optimize
    params_opt = free_params;
    for i = 1:length(freedom_syms)
        coords_i = freedom_syms(i);

        coords_idxs = find(params_opt == coords_i);
        params_opt(coords_idxs) = [];
    end

    oracle = @(x) double(subs(norm(eqs), params_opt, x));
    params0 = rand(size(params_opt));
    
    % Find model parameters
    options = optimoptions('fmincon', ...
                           'Display','iter',...
                           'Algorithm','sqp', ...
                           'UseParallel', 1, ...
                           'MaxIterations', 200);

    problem.objective = oracle;
    problem.x0 = params0;
    problem.solver = 'fmincon';
    problem.options = options;

    [sol, val] = fmincon(problem);

    % Time span
    time = 0:dt:T_val;
    
    coords = [];
    speeds = [];

    phi_prev = points(1).coords(4);
    for t_i = time
        symbs = [t; T; freedom_syms; params_opt];
        vals = [t_i; T_val; freedom_vals; sol];

        r_val = double(subs(r_t, symbs, vals));
        drdt_val = double(subs(drdt_t, symbs, vals));
        d2rdt2_val = double(subs(d2rdt2_t, symbs, vals));

        [rs_val, p_val] = traj2states_fun(r_val, drdt_val, ...
                                          d2rdt2_val, model_params);

        coords = [coords; rs_val'];
        speeds = [speeds; p_val'];
    end
    
end


