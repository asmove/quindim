function M = mass_matrix(sys)
    M = equationsToMatrix(sys.dyn.l_r, sys.kin.pp);
end
