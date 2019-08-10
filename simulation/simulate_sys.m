function sol = simulate_sys(sys, t, x0)
    df_ = @(t, q) df(t, q, sys);
    opts = odeset('RelTol',1e-5,'AbsTol',1e-6);
    
    sol = ode45(df_, t, x0, opts);
end

function dq = df(t, q_p_num, sys)
    dq_sym = subs(sys.dyn.f_subs, sys.syms, sys.model_params);
    dq_sym = vpa(dq_sym);
    
    q_p_sym = [sys.q; sys.p];
    dq_ = vpa(subs(dq_sym, q_p_sym, q_p_num));
    
    dq = double(dq_);
end