function sys = constraints_props(sys)
    % Constraint velocity matrix and its complementary
    [A, C] = constraint_matrices(sys);
    
    sys.kin.A = A;
    sys.kin.C = C;
    
    [~, m] = size(C);
    
    sys.kin.p = sym('p', [m, 1]);
    sys.kin.pp = sym('pp', [m, 1]);
end