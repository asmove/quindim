function p = poles(zeta, w_n)
    p = [w_n*(-zeta + j*sqrt(1 - zeta^2)); ...
         w_n*(-zeta - j*sqrt(1 - zeta^2))];
end