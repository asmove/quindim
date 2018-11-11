function U = potential_energy(body, gravity)
    U = -body.m*body.p_cg0.'*gravity;
end

