function val = poly_sat(actual, phi, degree)
    actual = (actual + phi)/2*phi;
    val = smoothstep(actual, phi, -1, 1, degree);
end