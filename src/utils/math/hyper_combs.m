function combs = hyper_combs(n, m)
    combs = 2^(n-m)*(factorial(n)/(factorial(m)*factorial(n-m)));
end