function body = build_body(m, inertia, b, Ts, p_cg, ...
                           q, qp, qpp, ...
                           fric_is_linear, previous, params)
    body.m = m;
    body.I = inertia;

    % Generalized coordinates
    body.q = q;
    body.qp = qp;
    body.qpp = qpp;
    
    % Previous body 
    body.previous_body = previous;
    
    % Body position transformations
    body.T = eye(4, 4);
    u = sym('u', size(q));
    assume(u, 'real');
    
    for T = Ts
        T_ = subs(T{1}, q, u);
        body.T = simplify(body.T*T_);
        body.T = subs(body.T, u, q);
    end
    
    body.p_cg = p_cg;
    
    % Friction information
    body.b = b;
    body.fric_is_linear = fric_is_linear;
    
    body.params = params;
end