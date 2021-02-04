function J = objective(params, t, y_true, func)
    A = params(1);
    zeta = params(2);
    
    y_predict = func(params, t);

	J = norm(y_true - y_predict)^2;
end