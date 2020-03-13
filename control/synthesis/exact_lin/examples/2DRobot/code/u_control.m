function [dz, u] = u_control(t, qp,  ref_func, sys, calc_u_func)
    persistent control_law dz_law ...
               y_ref yp_ref ypp_ref yppp_ref ...
               x_sym ref_syms;
    persistent model_params model_symbs symbs us counter;
    persistent num den nums dens;
    
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

        len_zx = length(dz_law) + ...
                 length(sys.kin.q) + ...
                 length(sys.kin.p{end});
        x_sym = sym('x_', [len_zx, 1]);
        
        model_params = sys.descrip.model_params;
        model_symbs = sys.descrip.syms;
        
        symbs = [x_sym; ref_syms; model_symbs.'];
    end
    
    vals = [qp; ref_func(t); model_params.'];
    
    dz = vpa(subs(dz_law, symbs, vals));
    
    [num, den] = numden(control_law);
    u = vpa(subs(control_law, symbs, vals));
    
    num_n = vpa(subs(num, symbs, vals));
    den_n = vpa(subs(den, symbs, vals));
    
    counter = counter + 1;
    if(counter == 1)
        us = [us; u'];
        nums = [nums; num_n'];
        dens = [dens; den_n'];
        assignin('base', 'input_torque', us);
        assignin('base', 'nums', nums);
        assignin('base', 'dens', dens);
    end
    
    if(counter == 4)
        counter = 0;
    end
end
