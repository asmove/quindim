function sys = constraints_props(sys)
    % Constraint velocity matrix and its complementary
    [A, C] = constraint_matrices(sys);
    
    sys.kin.As = {simplify_(A)};
    sys.kin.Cs = {simplify_(C)};
    
    sys.kin.A = simplify_(A);
    sys.kin.C = simplify_(C);
    
    [~, m] = size(C);
    
    sys.kin.p = {sym('p', [m, 1])};
    sys.kin.pp = {sym('pp', [m, 1])};
    
    sys = update_jacobians(sys, C);
end