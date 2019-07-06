function U = potential_energy(body, gravity)
    U = -body.m*body.p_cg0.'*gravity;
    U = simplify(U, 'Seconds', 15);
end

