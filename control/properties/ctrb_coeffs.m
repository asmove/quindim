function coeffs = ctrb_coeffs(poles)
    coeffs = my_poly(poles);
    coeffs = fliplr(coeffs(2:end));
end