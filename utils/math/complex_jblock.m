function Aw = complex_jblock(eig)
    sigma = real(eig);
    omega = imag(eig);
    Aw = [sigma, -omega; omega, sigma];
end