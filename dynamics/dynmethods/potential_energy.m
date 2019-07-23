function U = potential_energy(body, gravity)
    % Gravitational energy
    U = -body.m*body.p_cg0.'*gravity;
    
    % Springs
    for spring = body.springs
        curr = spring.head;
        prev = spring.tail;
        K = spring.k;
        
        % Elastic potential energy 
        Pk = (1/2)*K*(curr - prev).'*(curr - prev);
    end
    
    % Total potential energy
    U = U + Pk;
    
    U = simplify_(U);
end

