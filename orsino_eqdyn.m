function eqdyn = orsino_eqdyn(mechanism)
    
    % Number of subsystems
    num_subsystems = length(mechanism.serials);
    
    % Closed mechanism dynamic equation
    M_tilde = [];
    nu_tilde = [];
    g_tilde = [];
    U_tilde = [];
    D_circ = [];
    
    qp_circ = [];
    q_circ = [];
    p_circ = [];
    
    % Respective to serial systems
    for i = 1:num_subsystems
        serial = mechanism.serials{i};
        
        q = serial.generalized.q;
        qp = serial.generalized.qp;
        p = serial.generalized.p;
        pp = serial.generalized.pp;
        
        % Redundant variables for the closed mechanism
        q_circ = [q_circ, q];
        qp_circ = [qp_circ, qp];
        p_circ = [p_circ, p];
    
        % p = D*qp
        D =  equationsToMatrix(qp, p);
        mechanism.serial_sytems{i}.D = D;
        D_circ = blkdiag(D_circ, D);
        
        % dD/dt = Dp
        [qpp, Dp] = pp2qpp(D, q, qp, pp);
        mechanism.serial_sytems{i}.Dp = Dp;
        
        % p = D*qp <=> pp = Dp*qp + D*qpp <=> qpp = pinv(D)*(pp - Dp*qp)
        mechanism.serials{i}.qpp = qpp;
    
        % Serial dynamic equations               
        eqdyn = eqdyn_serial(serial);
        mechanism.serial_sytems{i}.eqdyn = eqdyn;
   
        % Serial systems unified representation
        M_i = eqdyn.M;
        nu_i = eqdyn.nu;
        g_i = eqdyn.g;
        U_i = eqdyn.U;
        
        M_tilde = blkdiag(M_tilde, M_i);
        nu_tilde = [nu_tilde; nu_i];
        g_tilde = [g_tilde; g_i];
        
        if(any(U_i))
            U_tilde = blkdiag(U_tilde, U_i);
        else
            U_i = zeros(size(U_i));
            U_tilde = [U_tilde; U_i];
        end        
    end
    
    % End-effector dynamic equation
    eqdyn_e = eqdyn_body_GAK(mechanism.endeffector);
    
    % Uncoupled multi-body system
    M_tilde = blkdiag(eqdyn_e.M, M_tilde);
    nu_tilde = [eqdyn_e.nu; nu_tilde];
    g_tilde = [eqdyn_e.g; g_tilde];
    
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
    Jac_circ = simplify(jacobian(constraints, q_circ));
    Jac_bullet = simplify(jacobian(constraints, q_bullet));   

    % Main matrices of thee dynamic equation
    eqdyn.Jac_circ = Jac_circ;
    eqdyn.Jac_bullet = Jac_bullet;
    eqdyn.D_circ = D_circ;
    eqdyn.D_bullet = D_bullet;
    eqdyn.M = M_tilde;
    eqdyn.g_decoupled = g_tilde;
    eqdyn.nu_decoupled = nu_tilde;
    eqdyn.U_decoupled = U_tilde;
    
end