function bconds = manifold_bounds(t, vars, vars0)
    bconds = [vars(1) - vars0(1); ...
              vars(2) - vars0(2)];
end