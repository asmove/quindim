function sys = dynamic_model(sys)
    sys = eqdyns(sys);
    sys.mass_matrix = mass_matrix(sys);
    sys.gravitational = gravitational(sys);
    sys.coriolis = simplify(sys.leqdyns - sys.mass_matrix*sys.qpp - sys.gravitational);
end