function [L, K, U] = lagrangian(body, gravity)
    K = kinetic_energy(body);
    U = potential_energy(body, gravity);
    L = simplify(K-U, 'Seconds', 30);
end
