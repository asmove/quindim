function M = mass_matrix(sys)
    M = equationsToMatrix(sys.l_r, sys.qpp);
end
