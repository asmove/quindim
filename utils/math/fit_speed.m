function [a, v0, tf] = fit_speed(t, speed, tf0_1)
    m = length(t);
    
    n = length(t);

    Ss = [];
    Ss = 0;
    
    for i = 2:n
        Ss(i) = Sk(Ss(i-1), i, t, speed);
    end
    
    S = [Ss', t', ones(n, 1)];

    coeffs = S\speed;
    
    a = -coeffs(1);
    v0 = -coeffs(2)/coeffs(1);
    
    speed_pred = v0*(1-exp(-a*t));
    speed_pred = speed_pred';
    
    options =  optimset('display','off');
    
    opt_func = @(tf, t) norm(100 - v0*(tf + (1/a)*exp(-a*tf) - 1/a));
    tf = fminsearch(opt_func, tf0_1, options);
end


