function friction = friction(sys, helper)
    fric_coeffs = [];
    for body = sys.descrip.bodies
        for damper = body.dampers
            if isempty(symvar(damper.b))
                continue;
            else
                fric_coeffs = [fric_coeffs; damper.b];
            end
        end
    end
    
    friction_component = equationsToMatrix(helper.l_r, fric_coeffs);
    friction = friction_component*fric_coeffs;

    if(isempty(friction))
         friction = zeros(length(helper.l_r), 1);
    end
end
