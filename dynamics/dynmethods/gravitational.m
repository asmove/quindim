function G = gravitational(sys)
    G = sys.descrip.g*equationsToMatrix(sys.dyn.l_r, sys.descrip.g);
    G = simplify_(G);
end