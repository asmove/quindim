function mechanism = load_mechanism(params_type)
    mechanism = struct();
    mechanism.serials = [];

    % Serial mechanisms
    mechanism.serials = load_serials(params_type);

    % End-effector
    mechanism.endeffector = load_endeffector(params_type);
    
    % Main points of the mechanism
    mechanism = load_aesthetics(mechanism);
    
    % Constraints
    mechanism.constraints = load_constraints(mechanism);

    % Implicit attributes for 
    mechanism.eqdyn = orsino_eqdyn(mechanism); 

    % Calculate value for q_circ
    [mechanism.q_circ_fun, mechanism.is_ws_fun] = load_q_circ(mechanism);
    
end