function [manifold, sol] = get_geodesic(tspan, manifold, x0, xf)
    % Intrinsic properties of a manifold
    manifold = manifold_params(manifold);
    
    x0 = [x0; 0; 0];
    xf = [xf; 0; 0];
    
    % Geodesic and respective constraints
    d_geodesic = @(t, x) geodesic(t, x, manifold);
    f_constraints = @(xa, xb) manifold_bounds(xa, xb, ...
                                              [x0; 0; 0], ...
                                              [xf; 0; 0]);
    
    % Boundary init and end points
    solinit = bvpinit(tspan, x0);
    sol = bvp5c(d_geodesic, f_constraints, solinit);
end