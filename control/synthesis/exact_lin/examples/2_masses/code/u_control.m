function [u, dz] = u_control(t, qp,  ref_func, ... 
                             sys, calc_u_func, options)
    persistent control_law dz_law ...
               y_ref yp_ref ypp_ref yppp_ref ...
               x_sym ref_syms;
    persistent model_params model_symbs symbs us counter;
    persistent num den nums dens u_curr t_1;
    double(qp)
    if(isempty(control_law))
        [dz_law, control_law] = calc_u_func();
    end
    
    if(isempty(t_1))
        t_1 = t;                               
    end
        
    if(isempty(u_curr))
        u_curr = zeros(size(sys.descrip.u));
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
    
    if(isfield(options, 'Ts'))
        Ts = options.Ts;
        if(t - t_1 > Ts)
            t_1 = t;
            u_curr = vpa(subs(control_law, symbs, vals));
        end
        
        u = u_curr;
    elseif(isfield(options, 'sigma_noise'))
        sigma_noise = options.sigma_noise;
        m = length(sys.descrip.u);
        z = zeros(m, 1);

        for i = 1:m
            z(i) = gaussianrnd(0, sigma_noise);
        end
        
        u = vpa(subs(control_law, symbs, vals));
        u = u + z;
    
    elseif(isfield(options, 'frequency') && ...
           isfield(options, 'amplitude'))
        w = options.frequency;
        A = options.amplitude;
        
        u = vpa(subs(control_law, symbs, vals));
        
        u = u + A*sin(w*t)*ones(length(u), 1);
        
    elseif(isfield(options, 'model_params'))
        model_params = options.model_params;
        vals = [qp; ref_func(t); model_params.'];
        
        m = length(sys.descrip.u);
        
        u = vpa(subs(control_law, symbs, vals));
    else
        u = vpa(subs(control_law, symbs, vals));
    end
    
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
