function sys = lagrangian(sys)
    K_ = [];
    U_ = [];
    F_ = [];
    
    for i = 1:length(sys.bodies)
        body = sys.bodies{i};
        sys.bodies{i}.K = kinetic_energy(body);
        sys.bodies{i}.U = potential_energy(body, sys.gravity);
        sys.bodies{i}.F = rayleigh_energy(body);
        sys.bodies{i}.L = sys.bodies{i}.K  - sys.bodies{i}.U; 
        
        K_ = [K_, sys.bodies{i}.K];
        U_ = [U_, sys.bodies{i}.U];
        F_ = [F_, sys.bodies{i}.F];
    end
    
    K = 0;
    U = 0;
    F = 0;

    for i = 1:length(sys.bodies)
        K = K + K_(i);
        U = U + U_(i);
        F = F + F_(i);
    end
    
    sys.K = K;
    sys.U = U;
    sys.L = simplify(K - U);
    sys.F = simplify(F);
end
