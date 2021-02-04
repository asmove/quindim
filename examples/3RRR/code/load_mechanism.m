function mechanism = load_mechanism(params_type)
    mechanism = struct();
    mechanism.serials = [];

    % Serial mechanisms
    mechanism.serials = load_serials(params_type);

    % End-effector
    mechanism.endeffector = load_endeffector(params_type);
    
    q = [];
    qp = [];
    p = [];
    pp = [];
    
    for i = 1:length(mechanism.serials)
        q_i = mechanism.serials{i}.generalized.q;
        qp_i = mechanism.serials{i}.generalized.qp;
        p_i = mechanism.serials{i}.generalized.p;
        pp_i = mechanism.serials{i}.generalized.pp;
        
        q = [q; q_i];
        qp = [qp; qp_i];
        p = [p; p_i];
        pp = [pp; pp_i];
    end
    
    mechanism.q = [mechanism.endeffector.generalized.q; q];
    mechanism.qp = [mechanism.endeffector.generalized.qp; qp];
    mechanism.p = [mechanism.endeffector.generalized.p; p];
    mechanism.pp = [mechanism.endeffector.generalized.pp; pp];
    
    % Main points of the mechanism
    mechanism = load_aesthetic(mechanism);
    
    % Constraints
    mechanism.constraints = load_constraints(mechanism);
end