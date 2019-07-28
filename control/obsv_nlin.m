function dobsv = obsv_nlin(f, y, x)
    n = length(f);
    obsv_ = y;
    lie_1 = y;
    
    for i = 1:n-1
        lie = simplify_(lie_diff(f, lie_1, x));
        obsv_ = [obsv_; lie];
        lie_1 = lie;
    end
    
    dobsv = jacobian(obsv_, x);
end