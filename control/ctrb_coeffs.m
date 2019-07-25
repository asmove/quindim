function coeffs = ctrb_coeffs(poles)
    coeffs = poly(poles);
    coeffs = fliplr(coeffs(2:end));
end