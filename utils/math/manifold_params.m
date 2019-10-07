function manifold = manifold_params(manifold)
    u = manifold.symvars(1);
    v = manifold.symvars(2);
    
    assume(u, 'real')
    assumeAlso(v, 'real')
    
    x_u = diff(manifold.surf, u);
    x_v = diff(manifold.surf, v);
    
    cross_uv = cross(x_u, x_v);
    N = cross_uv/norm(cross_uv);
    
    x_uu = diff(x_u, u);
    x_uv = diff(x_u, v);
    x_vv = diff(x_v, v);
    
    % First and second forms
    e = manifold.metric(N, x_uu);
    f = manifold.metric(N, x_uv);
    g = manifold.metric(N, x_vv);
    
    E = manifold.metric(x_u, x_u);
    F = manifold.metric(x_u, x_v);
    G = manifold.metric(x_v, x_v);
    
    % Curvature
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
             N, e, f, g, E, F, G, K, ...
             E_u, E_v, F_u, F_v, G_u, G_v};
    expr_simp = simplify_(exprs);
    
    Gamma_1_11 = Gamma(1);
    Gamma_2_11 = Gamma(2);
    Gamma_1_12 = Gamma(3);
    Gamma_2_12 = Gamma(4);
    Gamma_1_22 = Gamma(5);
    Gamma_2_22 = Gamma(6);
    
    manifold.E = simplify_(e);
    manifold.F = simplify_(f);
    manifold.G = simplify_(g);
    
    manifold.e = simplify_(E);
    manifold.f = simplify_(F);
    manifold.g = simplify_(G);
    
    manifold.K = K;
    
    manifold.Gamma_1_11 = Gamma_1_11;
    manifold.Gamma_2_11 = Gamma_2_11;
    manifold.Gamma_1_12 = Gamma_1_12;
    manifold.Gamma_2_12 = Gamma_2_12;
    manifold.Gamma_1_22 = Gamma_1_22;
    manifold.Gamma_2_22 = Gamma_2_22;
    
    manifold.x_u = x_u;
    manifold.x_v = x_v;
    
    manifold.x_uu = x_uu;
    manifold.x_uv = x_uv;
    manifold.x_vv = x_vv;
    
    manifold.N = vpa(N);
