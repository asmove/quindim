function G = gravitational(sys)
    G = sys.g*equationsToMatrix(sys.eqdyns, sys.g);
end