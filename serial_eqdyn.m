function s_eqdyn = serial_eqdyn(serial)
    n_bodies = length(fieldnames(serial.params));
    n_Ts = length(fieldnames(serial.params));

    if(n_Ts ~= n_bodies)
       error('Number of transformations MUST be the same as bodies.'); 
    end
    
    grav_vec = [];
    if(isfield(serial, 'gravity'))
        grav_vec = serial.gravity;
    end
    
    % Dimensionality
    n = size(serial.bodies{1}.params.cg);
    
    pv_circ = [];
    pw_circ = [];
    p_bullet = [];
    uf = [];
    um = [];
    Uf = [];
    Um = [];
    M_ = [];
    Lp = [];
    g = [];
    acg = [];
    
    % Useful generalized variables and their derivatives
    q = serial.bodies.generalized.q;
    qp = serial.bodies.generalized.qp;
    p = serial.bodies.generalized.p;
    pp = serial.bodies.generalized.pp;
    
    for i = 1:n_bodies
        T = serial.bodies{i}.T;
        R = R(1:3, 1:3);
        m = serial.bodies{i}.params.m;
        
        % p = D*qp
        D = equationsToMatrix(qp, p);
        Dp = dmatdt(D);
        qpp = simplify(pinv(D)*(pp - Dp*qp));
        
        % Center of mass position
        pcg_N = point(T, cg);
        
        % Center of mass speed
        vcg_N = dvdt(pcg_N, q, qp);
        vcg_i = R.'*vcg_N;
        
        % Center of mass acceleration
        acg_N = dvecdt(vcg_N, [q, qp], [qp, qpp]);
        acg_i = R.'*acg_N;
        acg = [acg; acg_i];
        
        % Body rotation
        Rp = dmatdt(R, q, qp);
        w_N = unskew(Rp*R.');
        w_i = R.'*w_N;
        
        % Angular acceleration
        wpi_N = dvecdt(w_N, [q, qp], [qp, qpp]);
        
        % Angular momentum
        Lpi = J*wpi_N + skew(wi_N)*J*wi_N;
        Lp = [Lp; Lpi];
        
        M = blkdiag(M, m*eyes(n, n));
        g = [g; m*grav_vec];
        
        pv_circ = [pv_circ; vcg_i];
        pw_circ = [pv_circ; w_i];
        
        p_bullet = [p_bullet; p];
                
        % Active excitations on the body
        symsf = serial.bodies(i).excitations.forces.symbs;
        symsm = serial.bodies(i).excitations.momenta.symbs;
        
        uf = [uf; symsf];
        um = [um; symsm];
        
        [F, Tau] = result_excitations(serial.bodies(i).excitations);
        
        % Coupling excitation matrix
        Uf_ = equationsToMatrix(F, symsf);
        Um_ = equationsToMatrix(Tau, symsm);
        
        Uf = blkdiag(Uf, Uf_);
        Um = blkdiag(Um, Um_);
    end
    
    U = blkdiag(Uf, Um);
    u = [uf, um];
    p_circ = [pv_circ; pw_circ];
    
    dp_circ_dp_bullet = jacobian(p_circ, p_bullet);
    
    leqdyn_ = dp_circ_dp_bullet.'*[M*acg - g; Lp];
    
    grav = symvar(grav_vec);
    eqdyn.g = simplify(equationsToMatrix(leqdyn_, grav));
    eqdyn.M = simplify(equationsToMatrix(leqdyn_, pp));
    eqdyn.nu = simplify(leqdyn_ - eqdyn.M*pp - eqdyn.g);
    eqdyn.U = simplify(dp_circ_dp_bullet.'*U);
    eqdyn.u = u;
    eqdyn.D = dp_circ_dp_bullet;
    eqdyn.acg = 
    eqdyn.w_n = 
end