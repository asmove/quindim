function z = curious_fun(t, xhat, m, oracle, nu, sigma, zeta)
    z0 = zeros(size(xhat));
    z = normrnd(z0, sigma);
end