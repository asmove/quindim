function M = mass_matrix(sys)
    u = sym('u', size(sys.qpp));
    
    qpp = [];
    for i = 1:length(sys.qpp)
        qpp = [qpp; sys.qpp{i}];
    end
    
    eqdyns_u = subs(sys.eqdyns, qpp, u);
    M = equationsToMatrix(eqdyns_u, u);
end
