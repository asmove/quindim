function sys = kinematic_model(sys)
    x = [sys.q; sys.qp];
    xp = [sys.qp; sys.qpp];
    
    n_bodies = length(sys.bodies);
    
    for i = 1:n_bodies
        body = sys.bodies(i);
        
        % Center of mass position
        p_cg = point(body.T, body.p_cg);
        sys.bodies(i).p_cg0 = p_cg;
        
        u = sym('u', size(formula(x)));
        assume(u, 'real');
        
        % Center of mass velocity - Quick hack
        p_cg_u = subs(p_cg, x, u);
        v_cg = jacobian(p_cg_u, u)*xp;
        v_cg = subs(v_cg, u, x);
        sys.bodies(i).v_cg = v_cg;
        
        % Body angular velocity
        T = formula(body.T);
        R = T(1:3, 1:3);
        sys.bodies(i).omega = omega(R, x, xp);
        
        if(i ~= n_bodies)
            sys.bodies(i+1).previous_body = sys.bodies(i); 
        end
    end
    
end