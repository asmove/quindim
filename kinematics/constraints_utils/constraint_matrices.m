function [A, C] = constraint_matrices(sys)
    % System contraints
    is_contrained = sys.descrip.is_constrained;
    is_holonomic = isfield(sys.descrip, {'hol_constraints'});
    is_nonholonomic = isfield(sys.descrip, {'unhol_constraints'});
    
    is_holonomic
    is_nonholonomic
    
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
            C = null(A);
            
        else
            hol_constraints = sys.descrip.hol_constraints;
            unhol_constraints = sys.descrip.unhol_constraints;
            
            A_hol = jacobian(hol_constraints, sys.kin.q);
            A_unhol = equationsToMatrix(unhol_constraints, sys.kin.qp);
            
            A = [A_hol; A_unhol];
            C = null(A);
        end
    else
        A = [];
        n = length(sys.kin.q);
        C = eye(n);
        
        sys.kin.p = sym('p', size(sys.kin.qp));
        sys.kin.pp = sym('pp', size(sys.kin.qp));
    end
    
% % Kinematic matrix without denominator     
%     
%     C = sym(dedenominatorify(C, sys.kin.q));
%     
%     [num_C, den_C] = numden(C);
%     
%     [m, n] = size(C);
%     
%     COUNT_THRES = 10;
%     count_simplify = 0;
%     
%     cond_exit = ((~isempty(symvar(den_C)) && count_simplify < COUNT_THRES));
%     
%     while(cond_exit)
%         C = dedenominatorify(C, sys.kin.q);
%         [num_C, den_C] = numden(C);
%         
%         count_simplify = count_simplify + 1;
%         
%         if(count_simplify == COUNT_THRES)
%             warning('The denominator may not be reduced further.');
%         end
%         
%         cond_exit = ((~isempty(symvar(den_C)) && (count_simplify < COUNT_THRES)));
%     end
%     
%     C = num_C./den_C;
end