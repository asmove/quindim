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
    body.T = collapse_transformations(Ts);
    
    body.dampers = dampers;
    body.springs = springs;
    
    % Center of mass
    body.p_cg = p_cg;
    
    body.params = params;
end