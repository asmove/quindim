function C = collapse_C(sys)
    n_C = length(sys.kin.Cs);
    n_q = length(sys.kin.q);    
    
    C = eye(n_q);
    
    for i = 1:n_C
        C = C*sys.kin.Cs{i};
    end
end