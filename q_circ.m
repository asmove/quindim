function [q_circ_, is_workspace] = q_circ(mechanism, q0_circ, q_bullet)
% Constraints
constraints = [];
for i = 1:length(mechanism.constraints)
    constraints = [constraints; mechanism.constraints{i}];
end

% Objective function
lconstraints = simplify(vpa(subs(constraints, mechanism.eqdyn.q_bullet, q_bullet)));

error = @(q_circ) double(subs(lconstraints, mechanism.eqdyn.q_circ, q_circ));
objective_fun = @(q_circ) error(q_circ).'*error(q_circ);


tol = 1e-3;
evals = 500;
% options = optimoptions(@fsolve, ...
%     'Display', 'iter-detailed', ...
%     'Algorithm', 'levenberg-marquardt', ...
%     'TolFun', tol, 'TolX', tol, ...
%     'MaxFunEvals', evals);
% 
options = optimoptions(@fsolve, ...
    'Display', 'iter-detailed', ...
    'TolFun', tol, 'TolX', tol, ...
    'MaxFunEvals', evals);
[q_circ_, objval] = fmincon(objective_fun, q0_circ,...
                            [],[],[],[],0,[],[], options);

% The most solutions converged within 100 iterations. When not, then
% the tolerance surpassed the stipulated value.
is_workspace = objval <= tol;
end
