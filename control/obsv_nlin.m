function d_obsv = obsv_nlin(f, h, x)
    n = length(f);
    obsv_ = h;
    lie_1 = h;
    
    for i = 1:n
        lie = simplify_(lie_diff(f, lie_1, x));
        obsv_ = [obsv_; lie];
        lie_1 = lie;
    end
    
    dobsv = jacobian(obsv_, x);
end