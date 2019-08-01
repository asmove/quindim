function friction = friction(sys)
    fric_coeffs = [];
    for body = sys.bodies
        for damper = body.dampers
            if isempty(symvar(damper.b))
                continue;
            else
                fric_coeffs = [fric_coeffs; damper.b];
            end
        end
    end
    
    friction_component = equationsToMatrix(sys.dyn.l_r, fric_coeffs);
    friction = friction_component*fric_coeffs;

    if(isempty(friction))
         friction = zeros(length(sys.dyn.l_r), 1);
    end
end
