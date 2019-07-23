function sol = validate_model(sys, t, x0, u0)
    sys.f_subs = subs(sys.f, sys.u, u0);
    
    t0 = tic;
    sol = simulate_sys(sys, t, x0);
    toc(t0);
end
