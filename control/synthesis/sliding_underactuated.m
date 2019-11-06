function u = sliding_underactuated(sys, etas, poles, ...
                                   params_lims, rel_qqbar, ...
                                   is_sat)    
    
    [U, S, V] = svd(sys.dyn.Z);
    sys.dyn.H = inv(U)*sys.dyn.H;
    sys.dyn.h = inv(U)*sys.dyn.h;
    sys.dyn.Z = S;
    q = sys.kin.q;
    
    D = equationsToMatrix(rel_qqbar, q);
    
    if(isempty(symvar(D*S)) && ~any(any(D*S)))
        error('The system cannot control this subspace!');
    end
        
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
    
    if(length(sys.kin.C) ~= 1)
        [m, ~] = size(sys.kin.C{1});
        
        Cs = eye(m);
        for i = 1:length(sys.kin.C)
            Cs = Cs*sys.kin.C{i};
        end
    else
        Cs = sys.kin.C{end};
    end
    
    p = p{end};
    
    qp = Cs*p;
    q_p = [q; qp];
    
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
    fs_hat_s
    fs_hat_n = subs(fs_hat_s, params_hat_s, params_hat_n);

    % Dynamics uncertainties
    Fs = dynamics_uncertainties(fs_s, q_p, params_s, params_lims);
    
    % Mass matrix uncertainties
    [D, Dtilde, Ms_hat_n] = mass_uncertainties(Ms_s, q_p, params_s, ...
                                                  params_lims);
    
    if(all(eig(Dtilde) > 1) || all(eig(Dtilde) < 0))
        error('D_tilde MUST have eigenvalues lower than 1 and greater than 0');
    end
                                            
    % Gains
    k = simplify_(inv(Dtilde)*(Fs + D*abs(sr_p + fs_hat_n) + etas));
    
    k = subs(k, params_hat_s, params_hat_n);
    K = vpa(diag(k));
    
    u_control = -inv(Ms_hat_n)*(fs_hat_n + sr_p + K*sign(s));
    u.output = vpa(u_control);
       
    % Manifold parameters
    u.lambda = [lambda_a, lambda_u];
    u.alpha = [alpha_a, alpha_u];
    
    % Dynamics approximations
    u.Ms_hat = vpa(Ms_hat_n);    
    u.fs_hat = vpa(fs_hat_n);
    
    u.fs_hat_s = fs_hat_s;
    u.fs_hat_n = fs_hat_n;
    
    u.K = K;
    
    % Maximum and minimum of mass matrix and dynamic vector
    u.D = double(D);
    u.Dtilde = double(Dtilde);
    u.Fs = double(Fs);
    
    % Sliding surface
    u.s = s;
    
    % Converting matrix
    u.U = U;
    u.V = V;
    
    u.sr = sr;
    u.sr_p = sr_p;
        
    u.params = params_s;
    u.params_hat = params_hat_s;
    
    u.etas = etas;
    u.is_sat = is_sat;
end
