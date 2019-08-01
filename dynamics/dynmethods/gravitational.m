function G = gravitational(sys)
    G = sys.g*equationsToMatrix(sys.dyn.l_r, sys.g);
    G = simplify(G, 'Seconds', 5);
end