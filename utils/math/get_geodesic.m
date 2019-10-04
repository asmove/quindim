function sol = get_geodesic(tspan, manifold, x0, vars)
    dx = geodesic(t, vars, manifold);

    sol = bvp5c(@geodesic, @manifold_bounds, x0);
end