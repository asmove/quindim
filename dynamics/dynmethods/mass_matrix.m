function M = mass_matrix(sys, helper)
    M = equationsToMatrix(helper.l_r, sys.kin.pp);
end
