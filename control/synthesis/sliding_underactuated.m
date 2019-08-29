function u = sliding_underactuated(sys, eta, poles, params_lims)
    % Matrices size
    [n, m] = size(sys.dyn.Z);
    
    % Generalized coordinates, velocities and accelerations
    q = sys.kin.q;
    qp = sys.kin.qp;
    qpp = sys.kin.qpp;
    
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

    Ms = alpha_a*inv(M_aa_prime) - ...
         alpha_u*inv(M_uu_prime)*M_au.'*inv(M_aa_prime);
    fs = alpha_a*inv(M_aa_prime)*f_a_prime + ...
         alpha_u*inv(M_uu_prime)*f_u_prime.';
    
    params_sym = sys.descrip.syms;
    params_hat = add_symsuffix(sys.descrip.syms, '_hat');
    
    fs_hat_sym = subs(fs, params_sym, params_hat);
    Ms_hat_sym = subs(Ms, params_sym, params_hat);
        
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
    
    sr_p = dvecdt(sr, [q; qp], [qp; qpp]);
    
    % Convergence on the manifold
    C = eig_to_matrix(poles);

    % Alpha and lambda project
    [n, m] = size(sys.dyn.Z);
    
    % Lambda and alpha parameters
    CI = [C, eye(size(C))];
    null_CI = null(CI);

    null_CI = sum(null_CI')';

    alpha_ = null_CI(1:n, 1:m).';
    lambda_ = null_CI(n+1:2*n, 1:m).';
    
    alpha_sym = [alpha_a, alpha_u];
    lambda_sym = [lambda_a, lambda_u];
    
    flat_lambda = flatten(lambda_sym);
    flat_alpha = flatten(alpha_sym);

    % Parameter limits
    params_min = params_lims(1, :);
    params_max = params_lims(2, :);

    params_mean = (params_min + params_max)/2;

    % Approximation mass matrix calculation
    Ms_min = subs(Ms, params_sym, params_min);
    Ms_max = subs(Ms, params_sym, params_max);
    Ms_hat = sqrt(Ms_min*Ms_max);
    disp('oi');
    fs_hat = subs(Ms, params_sym, params_mean);
    
    % Sliding gain
    Fs = abs(fs - fs_hat);
    Fs = subs(Fs, params_sym, params_min);
    Fs = subs(Fs, params_hat, params_max);
    
    K = diag(eta + Fs);
    
    % Control output
    u_control = -inv(Ms_hat)*(fs_hat + sr_p + K*sign(s));
    u_control = subs(u_control, flat_lambda, flatten(lambda_));
    u_control = subs(u_control, flat_alpha, flatten(alpha_));
    u.output = vpa(u_control);
    
    % Manifold parameters
    u.lambda = [lambda_a, lambda_u];
    u.alpha = [alpha_a, alpha_u];
    
    % Dynamics approximations
    u.Ms = Ms;
    
    u.Fs = Fs;
    u.fs = fs;
    u.fs_hat = fs_hat;
    
    u.sr = sr;
    u.sr_p = sr_p;
        
    u.params = params_sym;
    u.params_hat = params_hat;
    
    u.eta = eta;
end

