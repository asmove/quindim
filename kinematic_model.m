function sys = kinematic_model(sys)
    for i = 1:length(sys.bodies)
        body = sys.bodies{i};
        
        % Body velocity transformations
        sys.bodies{i}.Tp = Tp(body.T, sys.diffq, sys.varq);

        % Body acceleration transformations
        sys.bodies{i}.Tpp = Tpp(body.T, sys.diffq, sys.varq);

        % Center of mass position
        sys.bodies{i}.p_cg0 = point(body.T, body.p_cg);

        % Center of mass velocity
        sys.bodies{i}.v_cg = velocity(sys.bodies{i}.Tp, body.p_cg);
        
        % Body angular velocity
        sys.bodies{i}.omega = omega(body.T, sys.varq, sys.diffq);
    end
end