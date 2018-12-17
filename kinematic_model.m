function sys = kinematic_model(sys)
    x = [sys.q; sys.qp];
    xp = [sys.qp; sys.qpp];
        
    for i = 1:length(sys.bodies)
        body = sys.bodies{i};
        
        % Center of mass position
        p_cg = point(body.T, body.p_cg);
        sys.bodies{i}.p_cg0 = p_cg;

        % Center of mass velocity
        v_cg = jacobian(p_cg, x.')*xp;
        sys.bodies{i}.v_cg = v_cg;
        
        % Body angular velocity
        R = body.T(1:3, 1:3);
        sys.bodies{i}.omega = omega(R, x, xp);
    end
end