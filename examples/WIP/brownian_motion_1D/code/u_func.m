function [dz, u] = u_func(t, x, sigma, sys)
    p = x(1:2);
    wy = x(3:4);

    z = gaussianrnd(0, sigma);
    w = wy(1);
    y = wy(2);
    
    model_params = sys.descrip.model_params;
    
    m = model_params(1);
    b = model_params(2);
    k = model_params(3);
    
    dz = [z; w];
    
    u = - m*z - b*w - k*y;
end