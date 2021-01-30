function J = objective_tf(t, A, zeta)
    J = (100 - A*(t + (1/zeta)*exp(-zeta*t) - (1/zeta)))^2;
end