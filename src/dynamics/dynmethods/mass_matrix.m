function M = mass_matrix(sys, helper)
    M = equationsToMatrix(helper.m_term, sys.kin.qpp);
end
