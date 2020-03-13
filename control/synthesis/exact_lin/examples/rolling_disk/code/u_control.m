function [dz, u] = u_control(t, qp, ref_func, sys, calc_u_func)
    persistent control_law dz_law y_ref yp_ref ypp_ref yppp_ref x_sym ref_syms;
    persistent model_params model_symbs symbs us counter;
    
    if(isempty(control_law))       
        [dz_law, control_law] = calc_u_func();
    end
    
    if(isempty(counter))
        counter = 0;
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
    
    counter = counter + 1;
    if(counter == 1)
        us = [us; u'];
        assignin('base', 'input_torque', us);
    end
    
    if(counter == 4)
        counter = 0;
    end
end
