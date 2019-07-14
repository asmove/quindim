function d_obsv = obsv_nlin(f, h, x)
    n = length(f);
    obsv_ = h;
    lie_1 = h;
    
    for i = 1:n
        obsv_ = [obsv_; lie_diff(f, lie_1, x)];
        lie_1 = obsv_(end-1);
    end
    
    d_obsv = jacobian(obsv_, x);
end