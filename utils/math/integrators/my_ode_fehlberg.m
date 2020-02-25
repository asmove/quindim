function sol = my_ode_fehlberg(func, tspan, x0)
    sol = x0;
    x_1 = x0;
   
    tf = tspan(end);
    
    % vector related to RKF procdure
    gamma = [16/135; ...
             0; ...
             6656/12825; ...
             28561/56430; ...
             -9/50; ...
             2/55]; 
    
    % Time span
    dt = tspan(2) - tspan(1);

    wb = my_waitbar('Solving EDO...');
    
    % Core: Runge Kutta 6th order procedure
    for i = 2:length(tspan)
        t = tspan(i);

        k1 = dt*func(t, x_1);
        k2 = dt*func(t+dt/4, ...
                     x_1+k1/4);
        k3 = dt*func(t+3/8*dt, ...
                     x_1+3/32*k1+9/32*k2);
        k4 = dt*func(t+12/13*dt, ...
                     x_1+1932/2197*k1-7200/2197*k2+7296/2197*k3);
        k5 = dt*func(t+dt, ...
                     x_1+439/216*k1-8*k2+3680/513*k3-845/4104*k4);
        k6 = dt*func(t+dt/2, ...
                     x_1-8/27*k1+2*k2-3544/2565*k3+1859/4104*k4-11/40*k5);
        K = [k1, k2, k3, k4, k5, k6];
        x = x_1+ K*gamma;

        x_1 = x;
        sol(:, end+1) = x;
        
        wb.update_waitbar(t, tf);
    end
    
    wb.close_window();
end