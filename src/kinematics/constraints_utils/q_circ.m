function [q_circ_, is_ws] = q_circ(mechanism, q0_circ, q_bullet)

    % User-provided q_circ calculation
    if(isfield(mechanism, 'q_circ_fun') && isfield(mechanism, 'is_ws_fun'))
        q_circ_ = mechanism.q_circ_fun(q_bullet);
        is_ws = mechanism.is_ws_fun(q_bullet);
        return;
    end
    
    % Constraints
    constraints = [];
    for i = 1:length(mechanism.constraints)
        constraints = [constraints; mechanism.constraints{i}];
    end

    % Objective function
    consts = subs(constraints, mechanism.eqdyn.q_bullet, q_bullet);
    lconstraints = simplify(vpa(consts));
    
    error = @(q_circ) double(subs(lconstraints, mechanism.eqdyn.q_circ, q_circ));
    objective_fun = @(q_circ) error(q_circ).'*error(q_circ);

    tol = 1e-7;
    evals = 3000;

    options = optimoptions(@fsolve, ...
        'Display', 'iter-detailed', ...
        'TolFun', tol, 'TolX', tol, ...
        'MaxFunEvals', evals);
    [q_circ_, objval] = fmincon(objective_fun, q0_circ,...
                                [],[],[],[],0,[],[], options);

    % The most solutions converged within 100 iterations. When not, then
    % the tolerance surpassed the stipulated value.
    is_ws = objval <= tol;
end
