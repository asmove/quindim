function [dz, u] = compute_control(t, q_p, refs, qp_symbs, ...
                                   refs_symbs, sys, poles_, options)
    persistent control_law comp_law;
    persistent xppp yppp states_symbs m n;
    persistent y_ref yp_ref ypp_ref yppp_ref xpp ypp;
    
    if(isempty(comp_law))
        [comp_law, control_law, ~] = calc_control_2DRobot(sys, poles_);
    end
    
    if(isempty(y_ref))
        % Control and compensation law computation
        y_ref = add_symsuffix(sys.kin.q(1:2), '_ref');
        yp_ref = add_symsuffix(sys.kin.qp(1:2), '_ref');
        ypp_ref = add_symsuffix(sys.kin.qpp(1:2), '_ref');
        yppp_ref = add_symsuffix([xppp; yppp], '_ref');
        states_symbs = [qp_symbs; refs_symbs];
        [m, n] = size(sys.kin.C);
    end
    
    states_vals = [q_p; refs];
    
    u = subs(control_law, states_symbs, states_vals);
    dz = subs(comp_law, states_symbs, states_vals);
    
    % Sampling period
    if(isfield(options, 'Ts'))
        Ts = options.Ts;
        
        if(t - t_1 > Ts)
            t_1 = t;
            u_curr = vpa(subs(control_law, states_symbs, states_vals));
        end
        
        u = u_curr;
    
    % Inovation noise 
    elseif(isfield(options, 'amplitude'))
        A = getfield(options, 'amplitude');
        f = getfield(options, 'frequency');
        
        m = length(u);
        w = zeros(m, 1);

        for i = 1:m
            w(i) = A*sin(f*t);
        end
        
        u = u + w;
        
    elseif(isfield(options, 'sigma_noise'))
        sigma_noise = options.sigma_noise;
        m = length(sys.descrip.u);
        z = zeros(m, 1);

        for i = 1:m
            z(i) = gaussianrnd(0, sigma_noise);
        end
        
        u = vpa(subs(control_law, states_symbs, states_vals));
        u = u + z;
        
    % Parameter uncertainty
    elseif(isfield(options, 'model_params'))
        model_params = options.model_params;
        vals = [qp; ref_func(t); model_params.'];
        
        m = length(sys.descrip.u);
        
        u = vpa(subs(control_law, states_symbs, states_vals));
    
    % Exact control law
    else
        u = vpa(subs(control_law, states_symbs, states_vals));
    end
    
%     U_SAT = 5;
%     for i = 1:length(u)
%         if(abs(u(i)) > U_SAT)
%             u(i) = U_SAT;
%         end
%     end
end