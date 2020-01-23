function sol = validate_model(plant, x0, u_func, u_syms, qp_syms, tf, dt)
    df_ = @(t, q_p) df(t, q_p, plant, u_func, u_syms, qp_syms);

    t = 0:dt:tf;
    
    % Mass matrix
    sol = my_ode45(df_, t, x0);
end

function dq = df(t, q_p, plant, u_func, u_syms, qp_syms)
    t0 = tic;
    
    u = u_func(t, q_p);
    dq = vpa(subs(plant, [u_syms; qp_syms], [u; q_p]));
    
    % Time elapsed
    dt = toc(t0);
end

