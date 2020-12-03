function sys = calculate_jacobians(sys)
    n_bodies = length(sys.descrip.bodies);
    
    % System jacobian
    Jv = [];
    Jw = [];
    
    % States and its derivatives
    q = sys.kin.q;
    qp = sys.kin.qp;
    
    x = [sys.kin.q; sys.kin.qp];
    xp = [sys.kin.qp; sys.kin.qpp];
    
    for i = 1:n_bodies
        body_curr = sys.descrip.bodies{i};
        
        % Center of mass position
        sys.descrip.bodies{i}.p_cg0 = point(body_curr.T, body_curr.p_cg);
        
        % Center of mass velocity
        p_cg = sys.descrip.bodies{i}.p_cg0;

        sys.descrip.bodies{i}.v_cg = simplify_(jacobian(p_cg, x.')*xp);
        
        v_cg = sys.descrip.bodies{i}.v_cg;
        
        % Body angular velocity
        omega_ = body_curr.omega;
        
        sys.descrip.bodies{i}.omega = simplify_(omega_);
        
        if(i ~= n_bodies)
            sys.descrip.bodies{i+1}.previous_body = sys.descrip.bodies{i}; 
        end
        
        % Jacobians for each body
        Jvi = equationsToMatrix(v_cg, qp);
        Jwi = equationsToMatrix(omega_, qp);
        
        sys.descrip.bodies{i}.Jv = Jvi;
        sys.descrip.bodies{i}.Jw = Jwi;
        
        % System jacobian
        Jv = [Jv; Jvi];
        Jw = [Jw; Jwi];
    end
    
    % System jacobian
    sys.dyn.Jv = simplify_(Jv);
    sys.dyn.Jw = simplify_(Jw);
end