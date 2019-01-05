function [q_circ_, is_workspace] = q_circ(mechanism, q0_circ, q_bullet)
% Constraints
constraints = [];
for i = 1:length(mechanism.constraints)
    constraints = [constraints; mechanism.constraints{i}];
end

% Objective function
constraints = vpa(subs(constraints, mechanism.eqdyn.q_bullet, q_bullet));
dconsts = jacobian(constraints, mechanism.eqdyn.q_circ);

% Jacobian value
% Constraints
consts = @(q_circ) double(subs(constraints, ...
                               mechanism.eqdyn.q_circ, ...
                               q_circ));
% Constraints gradient
gradConst = @(q_circ) double(subs(dconsts, ...
                                  mechanism.eqdyn.q_circ, ...
                                  q_circ));

% Optimization funcs
const = @(q_circ) const_q_circ(q_circ, consts, gradConst);
                          
objective_fun = @(q_circ) 0.5*consts(q_circ).'*consts(q_circ);

options = optimoptions(@fmincon, ...
                        'Algorithm', 'interior-point', ...
                        'Display', 'final-detailed', ...
                        'UseParallel', true);

% Problem description                    
problem.objective = objective_fun;
problem.x0 = q0_circ;
problem.Aineq = [];
problem.bineq = []; 
problem.Aeq = [];
problem.beq = [];
problem.lb = [];
problem.ub = [];
problem.nonlcon = const;
problem.solver = 'fmincon'; 
problem.options = options;
                    
[q_circ_, objval] = fmincon(problem);

consts(q_circ_)

% The most solutions converged within 100 iterations. When not, then
% the tolerance surpassed the stipulated value.
is_workspace = objval <= 1e-6;
end
