function sys = dynamic_model(sys, method)
    
    sys = eqdyns(sys, method);
    sys.mass_matrix = mass_matrix(sys);
    sys.gravitational = gravitational(sys);
    sys.friction = friction(sys);
    sys.coriolis = simplify(sys.leqdyns - sys.mass_matrix*sys.qpp ...
                          - sys.gravitational - sys.friction);
end