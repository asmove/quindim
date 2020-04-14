function [u, dz] = u_control(t, qp, ref_func, sys, calc_u_func, T_pwm)
    persistent control_law dz_law;
    persistent y_ref yp_ref ypp_ref yppp_ref x_sym ref_syms;
    persistent model_params model_symbs 
    persistent symbs us counter t_1 u_curr;
    
    if(isempty(control_law))       
        [dz_law, control_law] = calc_u_func();
    end
    
    if(isempty(counter))
        counter = 0;
    end
    
    if(isempty(t_1))
        t_1 = t;
    end
    
    if(isempty(us))
        us = [];
    end
    
    if(isempty(x_sym))
        syms xppp yppp;
    
        y_ref = add_symsuffix(sys.kin.q(1:2), '_ref');
        yp_ref = add_symsuffix(sys.kin.qp(1:2), '_ref');
        ypp_ref = add_symsuffix(sys.kin.qpp(1:2), '_ref');
        yppp_ref = add_symsuffix([xppp; yppp], '_ref');

        ref_syms = [y_ref; yp_ref; ypp_ref; yppp_ref];
        x_sym = sym('x_', [7, 1]);
    
        model_params = sys.descrip.model_params;
        model_symbs = sys.descrip.syms;
        symbs = [x_sym; ref_syms; model_symbs.'];
    end
    
    vals = [qp; ref_func(t); model_params.'];    
    
    dz = vpa(subs(dz_law, symbs, vals));
    u = vpa(subs(control_law, symbs, vals));
    
%     if(isempty(u_curr))
%         t_1 = t;
%         u_curr = vpa(subs(control_law, symbs, vals));
%     end
%     
%     if(t - t_1 > T_pwm)
%         t_1 = t;
%         u_curr = vpa(subs(control_law, symbs, vals));
%     end
%     
%     u = u_curr;
    
%     sigma = 0.1;
%     for i = 1:length(u)
%         z_i = gaussianrnd(0, sigma);
%         u(i) = u(i) + z_i;
%     end
    
    counter = counter + 1;
    if(counter == 1)
        us = [us; u'];
        
        assignin('base', 'input_torque', us);
    end
    
    n_ode = 8;
    if(counter == n_ode)
        counter = 0;
    end
end
