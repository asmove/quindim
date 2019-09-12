function u = sliding_underactuated(sys, etas, poles, params_lims, rel_qqbar)    
    params_hat_n = sys.descrip.model_params';
    [n, m] = size(sys.dyn.Z);
    
    for i = 1:m
        param_lims = params_lims(i, 1:2);
        param_hat = params_hat_n(i);
        
        if((param_hat >= param_lims(1)) || (param_hat <= param_lims(2)))
            continue;
        else
            error('Estimation parameters MUST be within interval!');
        end
    end
    
    if(length(etas) ~= m)
        error('Number of etas MUST be equal to inputs!');
    end
    
    params_s = sys.descrip.syms.';
    params_hat_s = add_symsuffix(params_s, '_hat');
    
    q = sys.kin.q;
    p = sys.kin.p;
    
    q_a = q(1:m);
    q_u = q(m+1:n);
    p_a = p(1:m);
    p_u = p(m+1:n);
    
    q_p = [q; p];
    
    % Sliding constant matrices
    [alpha_a, alpha_u, lambda_a, lambda_u] = alpha_lambda(sys, poles, ...
                                                          rel_qqbar);
    
    % Matrix and dynamic matrices
    [Ms_s, fs_s] = Ms_fs(sys, alpha_a, alpha_u);
    
    % Sliding surface and auxiliary matrices
    [s, sr, sr_p] = s_sr_srp(sys, alpha_a, alpha_u, lambda_a, lambda_u);
    
    % Parameter limits
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);
    params_hat_n = (params_min + params_max)/2;
    
    fs_hat_s = subs(fs_s, params_s, params_hat_s);
    fs_hat_n = subs(fs_hat_s, params_hat_s, params_hat_n);

    % Dynamics uncertainties
    Fs = dynamics_uncertainties(fs_s, q_p, params_s, params_lims);
    
    % Mass matrix uncertainties
    [D, D_tilde, Ms_hat_n] = mass_uncertainties(Ms_s, q_p, ...
                                                params_s, params_lims);
    
    % Gains
    inv_I_Dtilde = inv(eye(m) - D_tilde);
    
    k = simplify_(inv_I_Dtilde*(Fs + D*abs(sr_p + fs_hat_n) + etas));
    
    k = subs(k, params_hat_s, params_hat_n);
    K = vpa(diag(k));
    
    % Control output
    u_control = -inv(Ms_hat_n)*(fs_hat_n + sr_p + K*sign(s));
    u.output = vpa(u_control);
    
    % Manifold parameters
    u.lambda = [lambda_a, lambda_u];
    u.alpha = [alpha_a, alpha_u];
    
    % Dynamics approximations
    u.Ms_hat = vpa(Ms_hat_n);    
    u.fs_hat = vpa(fs_hat_n);
    
    u.f_hat_s = fs_hat_s;
    
    u.K = K;
    
    % Maximum and minimum of mass matrix and dynamic vector
    u.D = D;
    u.D_tilde = D_tilde;
    u.Fs = Fs;
    
    % Sliding surface
    u.s = s;
       
    u.sr = sr;
    u.sr_p = sr_p;
        
    u.params = params_s;
    u.params_hat = params_hat_s;
    
    u.eta = etas;
end

