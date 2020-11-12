function [dz, u] = u_func(t, x, sigma_1, sigma_2, sys)
    p = x(1:4);
    wy = x(5:end);

    z_1 = gaussianrnd(0, sigma_1);
    z_2 = gaussianrnd(0, sigma_2);
    
    w_1 = wy(1);
    y_1 = wy(2);
    
    w_2 = wy(3);
    y_2 = wy(4);
    
    model_params = sys.descrip.model_params;
    
    m = model_params(1);
    b = model_params(2);
    k = model_params(3);
    
    dz = [z_1; w_1; z_2; w_2];
    
    u = - diag([m; m])*[w_1; w_2];
end