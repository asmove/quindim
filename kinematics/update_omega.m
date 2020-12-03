function body = update_omega(body, R, omega)
    if(isfield(body, 'omega'))
        body.omega = body.omega + R*omega;
    else
        body.omega = R*omega;
    end
end