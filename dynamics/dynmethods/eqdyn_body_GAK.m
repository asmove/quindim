function eqdyn = eqdyn_body_GAK(body)
    Uf = [];
    Um = [];
   
    % Dimensionality
    cardinality = length(body.params.cg);

    % Generalized coordinates
    q = body.generalized.q;
    qp = body.generalized.qp;
    
    p = body.generalized.p;
    pp = body.generalized.pp;
    
    % Transformation from base coordinate system
    T = simplify(body.T{1});

    % Rotation matrix
    R = T(1:3, 1:3);
    m = body.params.m;

    % p = D*qp
    D = equationsToMatrix(qp, p);

    % dD/dt = Dp
    [qpp, ~] = pp2qpp(D, q, qp, pp);

    % Center of mass position
    pcg_N = point(T, body.params.cg);

    % Center of mass speed
    vcg_N = dvecdt(pcg_N, q, qp);

    % Center of mass acceleration
    acg_N = dvecdt(vcg_N, [q; qp], [qp; qpp]);
    
    % Body rotation
    Rp = dmatdt(R, q, qp);
    w_N = simplify(unskew(Rp*R.'));
    w_i = R.'*w_N;
    
    % Angular acceleration
    wpi_N = dvecdt(w_N, [q; qp], [qp; qpp]);

    % Angular momentum
    J = body.params.J;
    Lp = J*wpi_N + skew(w_i)*J*w_i;

    M = m*eye(cardinality, cardinality);
    g = m*body.gravity;
    
    p_bullet = p;
    p_circ = [simplify(vcg_N); simplify(w_i)];

    % Active excitations on the body
    symsf = body.excitations.forces.symbs;
    symsm = body.excitations.momenta.symbs;

    uf = symsf;
    um = symsm;
    u = [uf; um];

    [F, Tau] = result_excitations(body.excitations, cardinality);

    % Actuation matrix
    if(isempty(symvar(norm(F))))
        Ufnew = zeros(cardinality, 1);
        Uf = [Uf; Ufnew];
    else
        Uf_ = equationsToMatrix(F, symsf); 
        Uf = blkdiag(Uf, Uf_);            
    end

    if(isempty(symvar(norm(Tau))))
        Umnew = zeros(cardinality, 1);
        Um = [Um; Umnew];
    else
        Um_ = equationsToMatrix(Tau, symsm);
        Um = blkdiag(Um, Um_);            
    end
    U = [Uf; Um];
    
    % Redundant variables and quasi-velocities
    dp_circ_dp_bullet = simplify(jacobian(p_circ, p_bullet));
        
    % Left side of dynamic equations
    leqdyn_ = dp_circ_dp_bullet.'*[M*acg_N - g; Lp];
    
    % Gravitational term
    eqdyn.g = dp_circ_dp_bullet.'*[g; zeros(size(Lp))];
    
    % Mass matrix
    eqdyn.M = simplify(equationsToMatrix(leqdyn_, pp));
    
    % Coriolis vector
    eqdyn.nu = simplify(leqdyn_ - eqdyn.M*pp - eqdyn.g);

    % Actuation vector
    eqdyn.U = simplify(dp_circ_dp_bullet.'*U);

    % Actuation
    eqdyn.u = u;

    % Quasi-velocities
    eqdyn.quasivelocities = dp_circ_dp_bullet;
end