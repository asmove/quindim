function G = gravitational(sys)
    G = sys.g*equationsToMatrix(sys.l_r, sys.g);
    G = simplify(G, 'Seconds', 30);
end