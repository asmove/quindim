function u = sliding_underactuated(sys, ...
                                   etas, poles, ...
                                   params_lims)
    [m, ~] = size(params_lims);
    
    params_hat_n = sys.descrip.model_params';
    
    for i = 1:m
        param_lims = params_lims(i, 1:2);
        param_hat = params_hat_n(i);
        
        if((param_hat >= param_lims(1)) || (param_hat <= param_lims(2)))
            continue;
        else
            error('Estimation parameters MUST be within interval!');
        end
    end
    
    % Matrices size
    [n, m] = size(sys.dyn.Z);
    
    % Generalized coordinates, velocities and accelerations
    q = sys.kin.q;
    qp = sys.kin.qp;
    p = sys.kin.p;
    pp = sys.kin.pp;
    
    params_s = sys.descrip.syms.';
    params_hat_s = add_symsuffix(params_s, '_hat');
    
    % Actuated and unactuated systems
    q_a = sys.kin.q(1:m);
    q_u = sys.kin.q(m+1:end);

    qp_a = sys.kin.p(1:m);
    qp_u = sys.kin.p(m+1:end);

    q_a_d = add_symsuffix(q_a, '_d');
    qp_a_d = add_symsuffix(qp_u, '_d');

    q_u_d = add_symsuffix(q_u, '_d');
    qp_u_d = add_symsuffix(qp_u, '_d');

    % Independent terms (gravitational, coriolis, friction)
    f = -sys.dyn.h;
    M = sys.dyn.H;

    % Mass Matrix
    M_aa = M(1:m, 1:m);
    M_au = M(1:m, m+1:end);
    M_uu = M(m+1:end, m+1:end);

    % Partitioned independent terms
    f_a = f(1:m);
    f_u = f(m+1:end);

    % Invertibility matrix
    alpha_a = sym('alpha_a_%d%d', [m, m]);
    alpha_u = sym('alpha_u_%d%d', [m, n-m]);

    lambda_a = sym('lambda_a_%d%d', [m, m]);
    lambda_u = sym('lambda_u_%d%d', [m, n-m]);

    M_aa_prime = M_aa + M_au*inv(M_uu)*M_au.';
    M_uu_prime = M_uu + M_au.'*inv(M_aa)*M_au;

    f_a_prime = f_a - M_au*inv(M_uu)*f_u;
    f_u_prime = f_u - M_au.'*inv(M_aa)*f_a;
    
    Ms_s = alpha_a*inv(M_aa_prime) - ...
         alpha_u*inv(M_uu_prime)*M_au.'*inv(M_aa_prime);
    fs_s = alpha_a*inv(M_aa_prime)*f_a_prime + ...
         alpha_u*inv(M_uu_prime)*f_u_prime.';
    
    % Sliding function
    error_a = q_a - q_a_d;
    errorp_a = qp_a - qp_a_d;
    
    error_u = q_u - q_u_d;
    errorp_u = qp_u - qp_u_d;
    
    s = alpha_a*errorp_a + lambda_a*error_a +...
        alpha_u*error_u + lambda_u*errorp_u;
    
    % Auxiliary variable
    sr = -alpha_a*qp_a_d - alpha_u*qp_u_d +...
          lambda_a*error_a + lambda_u*error_u;
    
    C_hat = subs(sys.kin.C, params_s, params_hat_s);
    sr_p = dvecdt(sr, [q; p], [C_hat*p; pp]);
    
    % Convergence on the manifold
    C = eig_to_matrix(poles);

    % Alpha and lambda project
    [n, m] = size(sys.dyn.Z);
    
    % Lambda and alpha parameters
    CI = [C', eye(size(C))];
    null_CI = null(CI);

    alpha_n = null_CI(1:n, 1:m).';
    lambda_n = null_CI(n+1:2*n, 1:m).';
    
    alpha_s = [alpha_a, alpha_u];
    lambda_s = [lambda_a, lambda_u];
    
    flat_lambda = flatten(lambda_s);
    flat_alpha = flatten(alpha_s);
    
    % Parameter limits
    params_min = params_lims(1, :);
    params_max = params_lims(2, :);
    
    fs_hat_s = subs(fs_s, params_s, params_hat_s);
    Ms_hat_s = subs(Ms_s, params_s, params_hat_s);
    
    x = [q; p];
    
    % Dynamics uncertainties
    Fs = dynamics_uncertainties(fs_s, fs_hat_s, x, ...
                                params_s, params_hat_s, params_lims);
                            
    % Mass matrix uncertainties
    [D, D_tilde] = mass_uncertainties(Ms_s, Ms_hat_s, x, ...
                                      params_s, params_hat_s, params_lims);
    
    % Gains
    k = simplify_(inv(eye(m) - D_tilde)*(Fs + ...
                  D*abs(sr_p + fs_hat_s) + etas));
    k = subs(k, params_hat_s, params_hat_n);
    k = subs(k, flat_lambda, flatten(lambda_n));
    k = subs(k, flat_alpha, flatten(alpha_n));
    
    K = vpa(diag(k));
    
    % Sliding surface
    s = subs(s, flat_lambda, flatten(lambda_n));
    s = subs(s, flat_alpha, flatten(alpha_n));
    
    Ms_hat_n = subs(Ms_hat_s, params_hat_s, params_hat_n);
    fs_hat_n = subs(fs_hat_s, params_hat_s, params_hat_n);
    
    % Control output
    u_control = -inv(Ms_hat_n)*(fs_hat_n + sr_p + K*sign(s));
    u.output = vpa(u_control);
    
    % Manifold parameters
    u.lambda = lambda_n;
    u.alpha = alpha_n;
    
    % Dynamics approximations
    u.Ms_s = Ms_s;
    u.Ms_hat_n = Ms_hat_n;
    
    % Maximum and minimum of mass matrix and dynamic vector
    u.D = D;
    u.D_tilde = D_tilde;
    
    u.Fs = Fs;
    
    u.Fs = Fs;
    u.fs = fs_s;
    u.fs_hat = fs_hat_s;
    
    u.sr = sr;
    u.sr_p = sr_p;
        
    u.params = params_s;
    u.params_hat = params_hat_s;
    
    u.eta = etas;
end

