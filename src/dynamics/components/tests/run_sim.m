w_n = torque_ref;

yrs = [];
xs = [];
xhats = [];
us = [];
alphas = [];

for ti = 0:dt:tf
    [yr, x, xhat, u, alpha] = motor_script(ti, w_n, params_u, params_plant);
    
    yrs = [yrs; yr];
    xs = [xs; x'];
    xhats = [xhats; xhat'];
    us = [us; u];
    alphas = [alphas; alpha];
end
