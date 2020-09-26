function [params_syms, ...
          params_sols, ...
          params_model] = ...
          gentrajmodel_2Drobot(t, traj_type, interval, points)

    syms T;
    t = sym('t');

    syms a0 a1 a2
    syms b0 b1 b2

    as = [a0; a1; a2];
    bs = [b0; b1; b2];
    free_params = [as; bs];

    lambda = t/T;

    switch traj_type
        case 'polynomial'
            x = a0 + a1*lambda + a2*lambda^2;
            y = b0 + b1*lambda + b2*lambda^2;
        case 'exp'
            x = a0 + a1*exp(lambda) + a2*exp(2*lambda);
            y = b0 + b1*exp(lambda) + b2*exp(2*lambda);
        case 'polynomial-cos'
            x = a0 + a1*t*cos(2*pi*lambda) + (t^2)*a2*cos(2*pi*2*lambda);
            y = b0 + b1*t*cos(2*pi*lambda) + (t^2)*b2*cos(2*pi*2*lambda);
        case 'exp-cos'
            x = a0 + a1*exp(lambda)*cos(2*pi*lambda) + ...
                exp(2*lambda)*a2*cos(2*pi*2*lambda);
            y = b0 + b1*exp(lambda)*cos(2*pi*lambda) + ...
                exp(2*lambda)*b2*cos(2*pi*2*lambda);
    end
    
    freedom_syms = [];
    freedom_vals = [];

    source_vars = sys.kin.q(1:2);

    q = sys.kin.q;
    qp = sys.kin.qp;

    n_q = length(q);

    r = symvar(source_vars).';

    drdt = sys.kin.qp(1:2);
    r_t = [x; y];
    drdt_t = diff(r_t, t);
    d2rdt2_t = diff(r_t, t);
    d3rdt3_t = diff(r_t, t);

    dxdt = diff(x, t);
    dydt = diff(y, t);
    constraints = sys.kin.A*sys.kin.qp;

    model_syms = sys.descrip.syms;
    model_params = sys.descrip.model_params;

    eqs_bounds = [r - r_t];
    eqs_constraints = constraints;

    nrbar = length(sys.kin.q) - length(r);
    
    r_syms = sym('r_', size(r));
    rbar_syms = sym('rbar_', nrbar);
    
    dr_syms = sym('dr_', size(r));
    drbar_syms = sym('drbar_', nrbar);

    symbs = [r; drdt; model_syms.'; freedom_syms];
    params = [r_syms; dr_syms; model_params.'; freedom_vals];

    eqs_bounds_symbs = subs(eqs_bounds, symbs, params);

    rbar = q;
    for i = 1:length(r_syms)
        coords_i = r(i);

        coords_idxs = find(rbar == coords_i);
        rbar(coords_idxs) = [];
    end
    
    params_opt = free_params;
    for i = 1:length(freedom_syms)
        coords_i = freedom_syms(i);

        coords_idxs = find(params_opt == coords_i);
        params_opt(coords_idxs) = [];
    end

    drbar = dvecdt(rbar, q, qp);

    symbs = [r; drdt; rbar; drbar; model_syms.'; freedom_syms];
    params = [r_t; drdt_t; rbar_syms; drbar_syms; model_params.'; freedom_vals];
    
    eqs_constraints_symbs = subs(eqs_constraints, symbs, params);
    
    eqs_symbs = [eqs_bounds_symbs; eqs_constraints_symbs];

    symbs0 = [t; r_syms; dr_syms; rbar_syms; drbar_syms];
    symbsT = [t; r_syms; dr_syms; rbar_syms; drbar_syms];

    eqs_syms = [eqs_bounds; eqs_constraints];

    model_syms = sys.descrip.syms;
    model_params = sys.descrip.model_params;

    q = sys.kin.q;
    qp = sys.kin.qp;

    eqs = [];
    for i = 1:length(points)
        t_i = points(i).t;
        coords = points(i).coords;
        
        r_vals = subs(r, q, coords);
        drdt_vals = subs(drdt, qp, coords);
        
        symbs = [r; drdt; model_syms.'; freedom_syms];
        params = [r_vals; drdt_vals; model_params.'; freedom_vals];
        eqs_bounds_i = subs(eqs_bounds, symbs, params);
        
        symbs = [q; drdt; model_syms.'; freedom_syms];
        params = [coords; drdt_t; model_params.'; freedom_vals];    
        eqs_constraints_i = subs(eqs_constraints, symbs, params);

        eqs_i = [eqs_bounds_i; eqs_constraints_i];

        symbs = [t; T];
        params = [t_i; interval];

        eqs_i = subs(eqs_i, symbs, params);

        eqs = [eqs; eqs_i];
    end

    eqs = subs(eqs, T, interval);

    A1 = sys.kin.As{1};

    A = -equationsToMatrix(eqs, params_opt);
    
    b = simplify_(A*params_opt + eqs);
    b = subs(b, freedom_syms, freedom_vals);
    
    sol = A\b;
    
    params_sols = sol;
    params_syms = free_params;
    params_model = r_t;
end
