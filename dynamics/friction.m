function friction = friction(sys)
    fric_coeffs = [];
    for body = sys.bodies
        if isempty(symvar(body(1).b))
            continue;
        else
            fric_coeffs = [fric_coeffs; body(1).b];
        end
    end
    
    friction_component = equationsToMatrix(sys.l_r, fric_coeffs);
    friction = friction_component*fric_coeffs;
end