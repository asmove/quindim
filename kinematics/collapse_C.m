function C = collapse_C(Cs, qs)
    n_C = length(Cs);
    n_q = length(qs);    
    
    Cs
    qs
    
    C = eye(n_q);
    
    for i = 1:n_C
        C = C*Cs{i};
    end
end