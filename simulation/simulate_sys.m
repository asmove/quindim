function sol = simulate_sys(sys, t, x0)
    df_ = @(t, q) df(t, q, sys);
    sol = ode23t(df_, t, x0);
end

function dq = df(t, q, sys)
    dq_sym = subs(sys.f_subs, sys.syms, sys.model_params);
    dq_sym = vpa(dq_sym);
    
    dq_ = vpa(subs(dq_sym, sys.states, q));
    
    dq = double(dq_);
end