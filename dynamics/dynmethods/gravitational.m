function G = gravitational(sys, helper)
    G = sys.descrip.g*equationsToMatrix(helper.l_r, sys.descrip.g);
    G = simplify_(G);
end
