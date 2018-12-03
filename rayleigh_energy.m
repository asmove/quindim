function F = rayleigh_energy(body)
    if body.fric_is_linear
        % TO FIX: Fix with contact point of body and viscuous fluid and
        % consider flows direction
        if(isfield(body.previous_body, 'v_cg'))
            F = (1/2)*body.b*(body.v_cg - body.previous_body.v_cg).'*...
                             (body.v_cg - body.previous_body.v_cg);          
        else
            F = (1/2)*body.b*body.v_cg.'*body.v_cg;
        end
    else
        if(isfield(body.previous_body, 'omega'))
            F = (1/2)*body.b*(body.omega - body.previous_body.omega).'*...
                 (body.omega - body.previous_body.omega);
        else
            F = (1/2)*body.b*body.omega.'*body.omega;            
        end
    end
end