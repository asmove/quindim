function [A, C] = constraint_matrices(sys)
    is_contrained = sys.descrip.is_constrained;
    is_holonomic = isfield(sys.descrip, {'hol_constraints'});
    is_nonholonomic = isfield(sys.descrip, {'unhol_constraints'});
    
    % Unholonomic constraitns
    if(is_contrained)
        if(is_nonholonomic && ~is_holonomic)
            constraints = sys.descrip.unhol_constraints;
            A = jacobian(constraints, sys.kin.qp);
            C = simplify_(null(A));
            
        % Holonomic constraitns
        elseif(is_holonomic && ~is_nonholonomic)
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
        n = length(sys.kin.q);
        C = eye(n);
    
        if(is_holonomic || is_nonholonomic)
            msg = ['When unconstrained, the fields hol_constraints and unhol_constraints cannot be presented.'];
            error(msg);
        end
    end
    
    x = [sys.kin.q; sys.kin.p];
    C = dedenominatorify(C, x);
end