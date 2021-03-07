function [yr_n, x_n, ...
          xhat_n, u_n, alpha_n] = motor_script(t, w_n, params_u, params_plant)
    % Static initialization
    persistent t0 alphan_1 yrn_1 en_1 xhatn_1 un_1 vn_1 u_ns xn_1;
    
    if(isempty(u_ns))
        nd_u = params_u.nd_u;
        u_ns = zeros(nd_u, 1);
    end
    
    if(isempty(vn_1))
        vn_1 = 0;
    end
    
    if(isempty(xn_1))
        xn_1 = params_plant.x0;
    end
    
    if(isempty(un_1))
        un_1 = 0;
    end
    
    if(isempty(en_1))
        en_1 = 0;
    end
    
    if(isempty(xhatn_1))
        yrn_1 = 0;
    end
    
    if(isempty(alphan_1))
        alphan_1 = 0;
    end
    
    if(isempty(xhatn_1))
        xhatn_1 = params_plant.xhat0;
    end
    
    if(isempty(t0))
        t0 = 0;
    end
    
    % Control loop
    delta_t = t - t0;
    Ts = params_u.Ts;
    
    if(delta_t >= Ts)
        % Current time
        t0 = t;
        
        % Plant parameters 
        Phi = params_plant.Phi;
        Gamma = params_plant.Gamma;
        C = params_plant.C;

        % Controller parameters
        L = params_u.L;
        Kp = params_u.Kp;
        Ki = params_u.Ki;

        % Actual states
        Phi_d = params_plant.Phi_d;
        Gamma_d = params_plant.Gamma_d;
        C_d = params_plant.C_d;
        Ctilde_d = params_plant.Ctilde_d;
        
        x_n = Phi_d*xn_1 + Gamma_d*alphan_1;
        y_n = C_d*x_n;

        % Estimate states
        xhat_n = Phi*xhatn_1 + Gamma*alphan_1 + L*(y_n - C*xhatn_1);

        % Tracking values
        x_n_ = [xhat_n; u_ns];
        v_n = vn_1 + en_1;

        u_p = - Kp*x_n_;
        u_i = Ki*v_n;
        
        % Duty cycle
        alpha_n = u_i + u_p;
        
        yr_n = Ctilde_d*x_n;
        
        % Memory values
        alphan_1 = alpha_n;
        yrn_1 = yr_n;
        xhatn_1 = xhat_n;
        xn_1 = x_n;
        vn_1 = v_n;
        en_1 = w_n - yr_n;
        u_ns = [alphan_1; u_ns(2:end)]; 
    else
        alpha_n = alphan_1;
        yr_n = yrn_1;
        x_n = xn_1;
        xhat_n = xhatn_1;
        u_n = un_1;
    end
    
    % PWM signal
    Vcc = params_u.Vcc;
    Tpwm = params_u.Tpwm;
    u_n = pwm_signal(t, Vcc, -Vcc, alpha_n, Tpwm);
    
    Ctilde_d = params_plant.Ctilde_d;
    yr_n = Ctilde_d*x_n;
    
    nd_i = params_u.nd_u;
    x_n = x_n(1:end-nd_i);
end
