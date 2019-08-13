function [A, C] = constraint_matrices(sys)
    is_contrained = sys.descrip.is_constrained;
    is_holonomic = isfield(sys.descrip, {'hol_constraints'});
    is_unholonomic = isfield(sys.descrip, {'unhol_constraints'});
    
    % Unholonomic constraitns
    if(is_contrained)
        if(is_unholonomic && ~is_holonomic)
            constraints = sys.descrip.unhol_constraints;
            A = jacobian(constraints, sys.kin.qp);
            C = simplify_(null(A));
            
        % Holonomic constraitns
        elseif(is_holonomic && ~is_unholonomic)
            constraints = sys.descrip.hol_constraints;
            A = jacobian(constraints, sys.kin.q);
            C = simplify_(null(A));

        else
            msg = 'When constrained, the fields hol_constraints' +...
                   'and unhol_constraints cannot be presented';
            error(msg);
        end
    else
        A = [];
        C = eye(length(sys.kin.q));
        
        if(is_holonomic || is_unholonomic)
            msg = 'When unconstrained, the fields hol_constraints' + ...
                  'and unhol_constraints cannot be presented.';
            error(msg);
        end
    end
end