function sol = get_geodesic(tspan, manifold, x0, xf)
    % Geodesic and respective constraints
    d_geodesic = @(t, x) geodesic(t, x, manifold, tspan(end));
    f_constraints = @(xa, xb) manifold_bounds(xa, xb, x0, xf);
    
    % Boundary init and end points
    solinit = bvpinit(tspan, x0);
    
    sol = bvp5c(d_geodesic, f_constraints, solinit);
end
