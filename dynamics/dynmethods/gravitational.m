function G = gravitational(sys, helper)
    G = sys.descrip.g*equationsToMatrix(helper.m_term, sys.descrip.g);
    G = simplify_(G);
end
