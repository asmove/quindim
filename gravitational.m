function G = gravitational(sys)
    G = sys.g*equationsToMatrix(sys.l_r, sys.g);
end