function sol = my_ode45(func, tspan, x0)
    sol = x0;
    x_1 = x0;
    
    wb = my_waitbar('Solving EDO...');
    
    tf = tspan(end);
    
    dt = tspan(2) - tspan(1);
    for t = tspan(1:end-1)
        k1 = func(t, x_1);
        k2 = func(t + dt/2, x_1 + dt*k1/2);
        k3 = func(t + dt/2, x_1 + dt*k2/2);
        k4 = func(t + dt, x_1 + dt*k3);
        
        x = x_1 + (dt/6)*(k1 + 2*k2 + 2*k3 + k4);
        
        wb.update_waitbar(t, tf);
        
        sol(:, end+1) = x;
        x_1 = x;
    end
    
    wb.close_window();
end