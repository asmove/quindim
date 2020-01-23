function K = kinetic_energy(body)
    body.v_cg
    K = (1/2)*body.m*body.v_cg.'*body.v_cg + ...
        (1/2)*body.omega.'*body.I*body.omega;
    
    K = simplify(K, 'Seconds', 10);
end