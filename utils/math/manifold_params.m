function manifold = manifold_params(manifold)
    u = manifold.symvars(1);
    v = manifold.symvars(2);
    
    assume(u, 'real')
    assumeAlso(v, 'real')
    
    x_u = diff(manifold.surf, u);
    x_v = diff(manifold.surf, v);
    
    cross_uv = cross(x_u, x_v);
    N = cross_uv/norm(cross_uv);
    
    N_u = diff(N, u);
    N_v = diff(N, v);

    e = -manifold.metric(N_u, x_u);
    f = -manifold.metric(N_v, x_u);
    g = -manifold.metric(N_v, x_v);
    
    E = manifold.metric(x_u, x_u);
    F = manifold.metric(x_u, x_v);
    G = manifold.metric(x_v, x_v);
    
    K = (e*g - f^2)/(E*G - F^2);
    
    E_u = diff(E, u);
    E_v = diff(E, v);
    F_u = diff(F, u);
    F_v = diff(F, v);
    G_u = diff(G, u);
    G_v = diff(G, v);
    
    EFFG = [E, F; F, G];
    Gamma_EFFG = blkdiag(EFFG, EFFG, EFFG);
    b_EFFG = [0.5*E_u; F_u - 0.5*E_v; 0.5*E_v; ...
              0.5*G_u; F_v - 0.5*G_u; 0.5*G_v];
    
    Gamma = Gamma_EFFG\b_EFFG;
    
    exprs = {x_u, x_v, cross_uv, ...
             N, N_u, N_v, ...
             e, f, g, E, F, G, K, ...
             E_u, E_v, F_u, F_v, G_u, G_v};
    expr_simp = simplify_(exprs);
    
    Gamma_1_11 = Gamma(1);
    Gamma_2_11 = Gamma(2);
    Gamma_1_12 = Gamma(3);
    Gamma_2_12 = Gamma(4);
    Gamma_1_22 = Gamma(5);
    Gamma_2_22 = Gamma(6);
    
    manifold.E = e;
    manifold.F = f;
    manifold.G = g;
    
    manifold.e = E;
    manifold.f = F;
    manifold.g = G;
    
    manifold.K = K;
    
    manifold.Gamma_1_11 = Gamma_1_11;
    manifold.Gamma_2_11 = Gamma_2_11;
    manifold.Gamma_1_12 = Gamma_1_12;
    manifold.Gamma_2_12 = Gamma_2_12;
    manifold.Gamma_1_22 = Gamma_1_22;
    manifold.Gamma_2_22 = Gamma_2_22;
