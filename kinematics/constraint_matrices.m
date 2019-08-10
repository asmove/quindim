function [A, C] = constraint_matrices(sys)
    is_contrained = sys.is_constrained;
    is_holonomic = isfield(sys, {'hol_constraints'});
    is_unholonomic = isfield(sys, {'unhol_constraints'});
    
    % Unholonomic constraitns
    if(is_contrained)
        if(is_unholonomic)
            constraints = sys.unhol_constraints;
            A = jacobian(constraints, sys.qp);
            C = simplify_(null(A));

        % Holonomic constraitns
        elseif(is_holonomic)
            constraints = sys.hol_constraints;
            A = jacobian(constraints, sys.q);
            C = simplify_(null(A));

        % Both
        elseif(is_holonomic && is_unholonomic)
            constraints = sys.hol_constraints;
            A_hol = jacobian(constraints, sys.q);
            A_unhol = jacobian(constraints, sys.qp);

            A = [A_hol; A_unhol];
            C = simplify_(null(A));

        else
            msg = 'When constrained, the fields hol_constraints' +...
                   'and unhol_constraints cannot be presented';
            error(msg);
        end
    else
        A = [];
        C = eye(length(sys.q));
        
        if(is_holonomic || is_unholonomic)
            msg = 'When unconstrained, the fields hol_constraints' + ...
                  'and unhol_constraints cannot be presented.';
            error(msg);
        end
    end
end