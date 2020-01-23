function [q_vals, p_vals, ...
          qp_vals, pp_vals, qpp_vals] = ...
                steering_smoothstep(t_i, ...
                                    interval_1, interval_2, interval_3, ...
                                    dt, degree_interp, symbs, ...
                                    model_params, points, sys)
    
    persistent phi_prev;
        
    % States derivatives
    if(t_i < 0)
        error(sprintf('t must be between %.3f and %.3f', ...
                      interval_1, interval_1 + interval_2 + interval_3));
    elseif((t_i > 0)&&(t_i <= interval_1))        
        dy = points(2).coords(2) - points(1).coords(2);
        dx = points(2).coords(1) - points(1).coords(1);
        theta_x = atan2(dy, dx);
        
        head = points(2).coords(3);
        tail = theta_x;
        
        theta_curr = smoothstep(t_i, interval, head, tail, degree_interp);
        thetap_curr = ndsmoothstep(t_i, interval, head, tail, degree_interp, 1);
        thetapp_curr = ndsmoothstep(t_i, interval, head, tail, degree_interp, 2);
        thetappp_curr = ndsmoothstep(t_i, interval, head, tail, degree_interp, 3);
        
        x_curr = points(1).coords(1);
        y_curr = points(2).coords(2);
        theta_curr = r_val;
        phi_curr = points(2).coords(4);
        
        % x and y time derivatives
        dxdt = 0;
        dydt = 0;

        dx2dt2 = 0;
        dy2dt2 = 0;

        dx3dt3 = 0;
        dy3dt3 = 0;
        
    elseif((t_i > interval_1)&&(t_i <= interval_1 + interval_2))
        head = points(1).coords(1:2);
        tail = points(2).coords(1:2);
        
        r_val = smoothstep(t_i, interval, head, tail, degree_interp);
        drdt_val = ndsmoothstep(t_i, interval, head, tail, degree_interp, 1);
        dr2dt2_val = ndsmoothstep(t_i, interval, head, tail, degree_interp, 2);
        dr3dt3_val = ndsmoothstep(t_i, interval, head, tail, degree_interp, 3);
        
        % x and y time derivatives
        dxdt = drdt_val(1);
        dydt = drdt_val(2);

        dx2dt2 = dr2dt2_val(1);
        dy2dt2 = dr2dt2_val(2);

        dx3dt3 = dr3dt3_val(1);
        dy3dt3 = dr3dt3_val(2);

        
    elseif((t_i > interval_1 + interval_2)&&...
           (t_i <= interval_1 + interval_2 + interval_3))
    end
    
    R = model_params(2);
        
    % Theta and v time derivatives
    if((dxdt == 0)&&(dydt == 0))
        x_1 = points(1).coords(1);
        x_2 = points(2).coords(1);
        
        y_1 = points(1).coords(2);
        y_2 = points(2).coords(2);
        
        delta_x = x_2 - x_1;
        delta_y = y_2 - y_1;
        
        theta = atan2(delta_y, delta_x);
        v = 0;
        
        omega_theta = 0;
        vp = dx2dt2*cos(theta) + dy2dt2*sin(theta) - ...
             dxdt*omega_theta*sin(theta) + dydt*omega_theta*cos(theta);
        omegap_theta = 0;
        omega_phi = v/R;
        omegap_phi = vp/R;
    
    else
        theta = atan2(dydt, dxdt);
    
        v = dxdt*cos(theta) + dydt*sin(theta);
    
        omega_theta = (-dx2dt2*sin(theta) + dy2dt2*cos(theta))/v;
        vp = dx2dt2*cos(theta) + dy2dt2*sin(theta) - ...
             dxdt*omega_theta*sin(theta) + dydt*omega_theta*cos(theta);
        omegap_theta = (-omega_theta*vp - ...
                         dx3dt3*sin(theta) + ...
                         dy3dt3*cos(theta) - ...
                         dx2dt2*omega_theta*cos(theta) - ...
                         dy2dt2*omega_theta*sin(theta))/v;

        omega_phi = v/R;
        omegap_phi = vp/R;

    end
    
    if(t_i == 0)
        phi = points(1).coords(4);
    else
        phi = phi_prev + dt*v/R;
    end

    phi_prev = phi;
    
    q_vals = double([r_val; theta; phi]);
    p_vals = double([omega_theta; omega_phi]);
    qp_vals = double([drdt_val; omega_theta; omega_phi]);
    pp_vals = double([omegap_theta; omegap_phi]);
    
    C = sys.kin.C;
    Cp = sys.kin.Cp;
    q = sys.kin.q;
    p = sys.kin.p{end};
    pp = sys.kin.pp{end};
    qp = sys.kin.qp;
    
    qpp = Cp*p + C*pp;
    
    symbs = [q; p; symbs.'];
    vals = [q_vals; p_vals; model_params'];
    
    qpp_vals = subs(qpp, symbs, vals);
end