function [params_syms, params_sols, ...
          params_model] = gentrajmodel_2Dmass(sys, traj_type, ...
                                              interval, points)

    syms T t;

%     syms a0 a1 a2
%     syms b0 b1 b2
    syms a0 a1
    syms b0 b1

    as = [a0; a1];
    bs = [b0; b1];
    free_params = [as; bs];

    lambda = t/T;

    switch traj_type
        case 'polynomial'
            x = a0 + a1*lambda;
            y = b0 + b1*lambda;
        case 'exp'
            x = a0 + a1*exp(lambda);
            y = b0 + b1*exp(lambda);
        case 'polynomial-cos'
            x = a0 + a1*t*cos(2*pi*lambda);
            y = b0 + b1*t*cos(2*pi*lambda);
        case 'exp-cos'
            x = a0 + a1*exp(lambda)*cos(2*pi*lambda);
            y = b0 + b1*exp(lambda)*cos(2*pi*lambda);
    end
    
    freedom_syms = [];
    freedom_vals = [];

    source_vars = sys.kin.q(1:2);

    q = sys.kin.q;
    qp = sys.kin.qp;

    n_q = length(q);

    r = symvar(source_vars)';

    drdt = sys.kin.qp(1:2);
    r_t = [x; y];
    drdt_t = diff(r_t, t);
    d2rdt2_t = diff(r_t, t);
    d3rdt3_t = diff(r_t, t);

    dxdt = diff(x, t);
    dydt = diff(y, t);

    model_syms = sys.descrip.syms;
    model_params = sys.descrip.model_params;

    eqs_bounds = [r - r_t];

    r_syms = sym('r_', size(r));
    rbar_syms = sym('rbar_', size(r));

    dr_syms = sym('dr_', size(r));
    drbar_syms = sym('drbar_', size(r));

    symbs = [r; drdt; model_syms.'; freedom_syms];
    params = [r_syms; dr_syms; model_params.'; freedom_vals];

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
    params = [r_t; drdt_t; r_syms; dr_syms; model_params.'; freedom_vals];    

    symbs0 = [t; r_syms; dr_syms; rbar_syms; drbar_syms];
    symbsT = [t; r_syms; dr_syms; rbar_syms; drbar_syms];

    eqs_syms = eqs_bounds;

    model_syms = sys.descrip.syms;
    model_params = sys.descrip.model_params;

    q = sys.kin.q;
    qp = sys.kin.qp;

    eqs = [];
    for i = 1:length(points)
        t_i = points(i).t;        
        coords_q = points(i).coords(1:n_q);

        r_vals = subs(r, q, coords_q);
        drdt_vals = subs(drdt, q, coords_q);

        symbs = [r; drdt; model_syms.'; freedom_syms];
        params = [r_vals; drdt_vals; model_params.'; freedom_vals];
        eqs_bounds_i = subs(eqs_bounds, symbs, params);

        eqs_i = eqs_bounds_i;

        symbs = [t; T];
        params = [t_i; interval];

        eqs_i = subs(eqs_i, symbs, params);

        eqs = [eqs; eqs_i];
    end
    
    eqs = subs(eqs, T, interval);

    A = -equationsToMatrix(eqs, params_opt);
    
    b = simplify_(A*params_opt + eqs);
    b = subs(b, freedom_syms, freedom_vals);
    
    sol = A\b;
    
    params_sols = sol;
    params_syms = free_params;
    params_model = r_t;
end
