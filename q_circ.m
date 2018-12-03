function q_circ_ = q_circ(mechanism, q0_circ, q_bullet)
    % Constraints
    constraints = [];
    for i = 1:length(mechanism.constraints)
        constraints = [constraints; mechanism.constraints{i}];
    end
    
    % Objective function
    error = @(q_circ_) subs(constraints, ...
                            [mechanism.q_bullet, mechanism.q_circ_], ...
                            [q_bullet, q_circ_]);
    objective_fun = @(q_circ_) error(q_circ_).'*error(q_circ_);
    
    q_circ_ = fminunc(objective_fun, q0_circ);
end