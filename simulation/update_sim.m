function sim_ = update_sim(i, sim, mechanism, trajectory)   
    n_bullet = length(mechanism.eqdyn.q_bullet);
    n_circ = length(mechanism.eqdyn.q_circ);

    % First iteration
    if(i == 1)
        % Instants
        prev_t = deal(trajectory.t(1));
        curr_t = deal(trajectory.t(2));
        
        % Generalized variables
        q0_circ = zeros(n_circ, 1);
    else
        % Instants
        prev_t = deal(trajectory.t(i-1));
        curr_t = deal(trajectory.t(i));
        
        q0_circ = sim.q(n_bullet+1:end);
    end
    
    % Current bullet
    q_bullet = trajectory.q(i, :).';
    qp_bullet = trajectory.qp(i, :).';
    qpp_bullet = trajectory.qpp(i, :).';
    
    [q, qp, p, pp, ~] = q_qp_p(mechanism, ...
                               q0_circ, ...
                               q_bullet, ...
                               qp_bullet, ...
                               qpp_bullet);
                           
    % Main generalized variables
    sim_.t = trajectory.t(i);
    sim_.q = q;
    sim_.qp = qp;
    sim_.p = p;
    sim_.pp = pp;

    q_sym = [mechanism.eqdyn.q_bullet; mechanism.eqdyn.q_circ];
    qp_sym = [mechanism.eqdyn.qp_bullet; mechanism.eqdyn.qp_circ];
    p_sym = mechanism.eqdyn.p_bullet;
    
    q_num = q;
    qp_num = qp;
    p_num = p;
        
    [C, ~, Cp] = coupling_matrixC(mechanism, q, qp);
    
    [sim_(:).C] = deal(C);
    [sim_(:).Cp] = deal(Cp);
    
    % Main points of mechanism
    sim_.points = eval_points(mechanism, q);

    % First iteration
    if(isempty(fieldnames(sim)))
        [sim_(:).q_error] = deal(0);
    else
        inf_norm_error = max(abs(sim.q - sim_.q));
        sim_.q_error = deal(inf_norm_error);
    end

    % Constraints error
    n = length(mechanism.constraints);

    consts = sym(zeros(n, 1));
    for j = 1:n
        consts(j) = mechanism.constraints{j};
    end
    
    inf_norm_const = max(abs(double(subs(consts, q_sym, q_num))));
    [sim_(:).constraints_error] = deal(inf_norm_const);
    sim_.constraints = consts;
    
    % Actions of actuators
    Mtilde = double(subs(mechanism.eqdyn.M_decoupled, q_sym, q_num));
    Utilde = double(subs(mechanism.eqdyn.U_decoupled, q_sym, q_num));
    nutilde = double(subs(mechanism.eqdyn.nu_decoupled, ...
                          [q_sym; qp_sym; p_sym], [q_num; qp_num; p_num]));
    gtilde = double(subs(mechanism.eqdyn.g_decoupled, q_sym, q_num));
                                      
    M = double(Mtilde);
    U = double(Utilde);
    nu = double(nutilde);
    g = double(gtilde);
    
    p_bullet_ = p(1:n_bullet);
    pp_bullet_ = pp(1:n_bullet);
    
    % Main action variables
    H = double(C.'*M*C);
    Z = double(C.'*U);
        
    h = double(C.'*(M*Cp*p_bullet_ + nu - g));
    
    u = double(pinv(Z)*(H*pp_bullet_ + h));
    
    [sim_(:).u] = deal(u);
end
