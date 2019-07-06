function eqdyn = gibbs_appel_eqdyn(mechanism)
    % Number of subsystems
    num_subsystems = length(mechanism.serials);
    
    % Closed mechanism dynamic equation
    M_tilde = [];
    nu_tilde = [];
    g_tilde = [];
    U_tilde = [];
    D_circ = [];
    
    q_circ_ = [];
    qp_circ = [];
    p_circ = [];
    pp_circ = [];
    
    % Respective to serial systems
    for i = 1:num_subsystems
        mechanism.serials{i} = build_dynserial(mechanism.serials{i});
        
        serial = mechanism.serials{i};
               
        % Redundant variables for the closed mechanism
        q_circ_ = [q_circ_; serial.q];

        qp_circ = [qp_circ; serial.qp];
        p_circ = [p_circ; serial.p];
        pp_circ = [pp_circ; serial.pp];
    
        % p = D*qp
        D_circ = blkdiag(D_circ, serial.D);

        
        M_tilde = blkdiag(M_tilde, serial.M);
        nu_tilde = [nu_tilde; serial.nu];
        g_tilde = [g_tilde; serial.g];
        
        if(any(any(serial.U)))
            U_tilde = blkdiag(U_tilde, serial.U);
        else
            U_i = zeros(size(serial.U));
            U_tilde = [U_tilde; U_i];
        end
    end
    
    % End-effector dynamic equation - Newton's equation
    eqdyn_e = eqdyn_body_GAK(mechanism.endeffector);
    
    % Uncoupled multi-body system
    M_tilde = blkdiag(eqdyn_e.M, M_tilde);
    nu_tilde = [eqdyn_e.nu; nu_tilde];
    g_tilde = [eqdyn_e.g; g_tilde];
    
    if(any(any(eqdyn_e.U)))
        U_tilde = blkdiag(eqdyn_e.U, U_tilde);
    else
        [~, n] = size(U_tilde);
        [m, ~] = size(eqdyn_e.U);
        
        U_e = zeros(m, n);
        U_tilde = [U_e; U_tilde];
    end
    
    % Generalized variables and their derivatives
    q_bullet = mechanism.endeffector.generalized.q;
    qp_bullet = mechanism.endeffector.generalized.qp;
      
    p_bullet = mechanism.endeffector.generalized.p;
    pp_bullet = mechanism.endeffector.generalized.pp;

    D_bullet =  equationsToMatrix(qp_bullet, p_bullet);
    
    constraints = [];
    for i = 1:length(mechanism.constraints)
        constraints = [constraints; mechanism.constraints{i}];
    end
        
    % Jacobians
    Jac_circ = simplify(jacobian(constraints, q_circ_));
    Jac_bullet = simplify(jacobian(constraints, q_bullet));   
    
    % Independent and redundant variables
    eqdyn.q_bullet = q_bullet;
    eqdyn.p_bullet = p_bullet;
    eqdyn.qp_bullet = qp_bullet;
    eqdyn.pp_bullet = pp_bullet;

    [~, Dp_bullet] = pp2qpp(D_bullet, q_bullet, qp_bullet, pp_bullet);
    mechanism.serial_sytems{i}.Dp = Dp_bullet;
    
    n_bullet = length(q_bullet);
    
    eqdyn.D_bullet = vpa(D_bullet);
    eqdyn.Dp_bullet = vpa(Dp_bullet);
    
    eqdyn.q_circ = q_circ_;
    eqdyn.p_circ = p_circ;
    eqdyn.qp_circ= qp_circ;
    eqdyn.pp_circ = pp_circ;

    [~, Dp_circ] = pp2qpp(D_circ, q_circ_, qp_circ, pp_circ);
    eqdyn.D_circ = vpa(D_circ);
    eqdyn.Dp_circ = vpa(Dp_circ);
    
    n_circ = length(q_circ_);
    
    % Main jacobians and their derivatives
    eqdyn.Jac_circ = vpa(Jac_circ);
    eqdyn.Jac_bullet = vpa(Jac_bullet);
    
    eqdyn.Jacp_circ = vpa(dmatdt(Jac_circ, q_circ_, qp_circ));
    eqdyn.Jacp_bullet = vpa(dmatdt(Jac_bullet, q_bullet, qp_bullet));
    
    % Matrix of velocity coupling - Maggi
    eqdyn.A = [eqdyn.Jac_bullet/eqdyn.D_bullet, ...
               eqdyn.Jac_circ/eqdyn.D_circ];
    
    % D matrix is commonly constant
    eqdyn.Ap = [];
    if(det(eqdyn.Dp_bullet))
        eqdyn.Ap = [eqdyn.Ap, eqdyn.Jacp_bullet/eqdyn.D_bullet + ... 
                              eqdyn.Jac_bullet/eqdyn.Dp_bullet];
    else
        eqdyn.Ap = [eqdyn.Ap, eqdyn.Jacp_bullet/eqdyn.D_bullet];
    end
    
    if(det(eqdyn.Dp_circ))
        eqdyn.Ap = [eqdyn.Ap, eqdyn.Jacp_circ/eqdyn.D_circ + ... 
                              eqdyn.Jac_circ/eqdyn.Dp_circ];
    else
        eqdyn.Ap = [eqdyn.Ap, eqdyn.Jacp_circ/eqdyn.D_circ];
    end
                          
    % Useful matrices for Cp computation
    eqdyn.Q_bullet = [eye(n_bullet); zeros(n_circ, n_bullet)];
    eqdyn.Q_circ = [zeros(n_bullet, n_circ); eye(n_circ)];
    
    % Main matrices of the dynamic equation  
    eqdyn.M_decoupled = vpa(M_tilde);
    eqdyn.g_decoupled = vpa(g_tilde);
    eqdyn.nu_decoupled = vpa(nu_tilde);
    eqdyn.U_decoupled = vpa(U_tilde);
end
