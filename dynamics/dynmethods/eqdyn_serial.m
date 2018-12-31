function eqdyn = eqdyn_serial(serial)
    n_bodies = length(serial.bodies);
        
    % Dimensionality
    cardinality = length(serial.bodies{1}.params.cg);
    
    % Useful generalized variables and their derivatives
    q = serial.generalized.q;
    qp = serial.generalized.qp;
    
    p = serial.generalized.p;
    pp = serial.generalized.pp;
    
    % Generalized independet variables
    p_bullet = p;
    
    % Empty vec for each body
    pv_circ = [];
    pw_circ = [];
    uf = [];
    um = [];
    Uf = [];
    Um = [];
    M = [];
    Lp = [];
    g = [];
    acg = [];
    
    for i = 1:n_bodies
        body = serial.bodies{i};
        
        % Transformation from base coordinate system
        T = simplify(body.T);
        
        % Rotation matrix
        R = T(1:3, 1:3);
        m = body.params.m;
        
        % p = D*qp
        D = equationsToMatrix(qp, p);
        
        % dD/dt = Dp
        Dp = dmatdt(D, q, qp);
        
        % p = D*qp <=> pp = Dp*qp + D*qpp <=> qpp = pinv(D)*(pp - Dp*qp)
        qpp = simplify(pinv(D)*(pp.' - Dp*qp.')).';
        
        % Center of mass position
        pcg_N = point(T, body.params.cg);
        
        % Center of mass speed
        vcg_N = dvecdt(pcg_N, q, qp);
        vcg_i = R.'*vcg_N;
        
        % Center of mass acceleration
        acg_N = dvecdt(vcg_N, [q, qp], [qp, qpp]);
        acg_i = simplify(R.'*acg_N);
        acg = [acg; acg_i];
        
        % Body rotation
        Rp = dmatdt(R, q, qp);
        w_N = simplify(unskew(Rp*R.'));
        w_i = simplify(R.'*w_N);
        
        % Angular acceleration
        wpi_N = dvecdt(w_N, [q, qp], [qp, qpp]);
        
        % Angular momentum
        J = body.params.J;
        Lpi = J*wpi_N + skew(w_i)*J*w_i;
        Lp = [Lp; Lpi];
        
        M = blkdiag(M, m*eye(cardinality, cardinality));
        g = [g; m*serial.gravity];
        
        pv_circ = [pv_circ; simplify(vcg_i)];       
        pw_circ = [pw_circ; simplify(w_i)];
        
        % Active excitations on the body
        symsf = body.excitations.forces.symbs;
        symsm = body.excitations.momenta.symbs;
        
        uf = [uf; symsf];
        um = [um; symsm];
        
        [F, Tau] = result_excitations(body.excitations, cardinality);
        
        % Update actuation matrix
        if(isempty(symvar(norm(F))))
            Ufnew = zeros(cardinality, 1);
            Uf = [Uf; Ufnew];
        else
            Uf_ = equationsToMatrix(F, symsf); 
            Uf = blkdiag(Uf, Uf_);            
        end
        
        if(isempty(symvar(norm(Tau))))
            Umnew = zeros(size(Um));
            Um = [Um; Umnew];
        else
            Um_ = equationsToMatrix(Tau, symsm);
            Um = blkdiag(Um, Um_);            
        end
    end
    
    % Actuation matrix
    U = [Uf; Um];
    u = [uf, um];
    
    % Redundant variables and quasi-velocities
    p_circ = simplify([pv_circ; pw_circ]);
    dp_circ_dp_bullet = simplify(jacobian(p_circ, p_bullet));
        
    % Left side of dynamic equations
    leqdyn_ = dp_circ_dp_bullet.'*[M*acg - g; Lp];
    
    % Gravitational term
    eqdyn.g = -dp_circ_dp_bullet.'*[g; zeros(size(Lp))];
    
    % Mass matrix
    eqdyn.M = simplify(equationsToMatrix(leqdyn_, pp));
    
    % Coriolis vector
    eqdyn.nu = simplify(leqdyn_ - eqdyn.M*pp.' - eqdyn.g);

    % Actuation vector
    eqdyn.U = simplify(dp_circ_dp_bullet.'*U);

    % Actuation
    eqdyn.u = u;

    % Quasi-velocities
    eqdyn.quasivelocities = dp_circ_dp_bullet;

    % Aceleration
    eqdyn.acg = acg;
end