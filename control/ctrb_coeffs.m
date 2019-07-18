function coeffs = ctrb_coeffs(poles)
    coeffs = poly(poles);
    coeffs = fliplr(coeffs(1:end-1));
end