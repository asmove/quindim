function body = build_body(m, inertia, Ts, p_cg, dampers, springs, ...
                           q, qp, qpp, previous, params)
    
    if(nargin == 0)
       body.m = 0;
       body.I = eye(3);
       body.q = [];
       body.qp = [];
       body.qpp = [];
       body.springs = [];
       body.dampers = [];
       body.q = [];
       body.qp = [];
       body.qpp = [];
       return;
    end
                       
    body.m = m;
    body.I = inertia;

    % Generalized coordinates
    body.q = q;
    body.qp = qp;
    body.qpp = qpp;
    
    % Previous body 
    body.previous_body = previous;
    
    % Body position transformations
<<<<<<< HEAD
    body.T = eye(4, 4);
    u = sym('u', size(formula(q)));
    assume(u, 'real');
    
    % Quick hack to allow matrix simplifications
    for T = Ts
        T_ = subs(formula(T{1}), q, u);
        body.T = simplify(body.T*T_);
        body.T = subs(body.T, u, q);
    end
=======
    body.T = collapse_transformations(Ts);
    
    body.dampers = dampers;
    body.springs = springs;
>>>>>>> 7ecfa11ac4f207662b7b27f4bae251d295c0a6bb
    
    % Center of mass
    body.p_cg = p_cg;
    
    body.params = params;
end