function [L, K, U] = lagrangian(body, gravity)   
    body.K = kinetic_energy(body);
    body.U = potential_energy(body, gravity);
    body.L = body.K  - body.U; 
end
