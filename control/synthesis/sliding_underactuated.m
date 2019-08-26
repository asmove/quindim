function u = sliding_underactuated(sys, eta, poles, params_lims)
    % Matrices size
    [~, m] = size(sys.dyn.Z);
    
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
    M = -sys.dyn.H;

    % Mass Matrix
    M_aa = M(1, 1);
    M_au = M(1, 2);
    M_uu = M(2, 2);

    % Partitioned independent terms
    f_a = f(1);
    f_u = f(2);

    % Tuning parameters
    eta = 1;

    [n, m] = size(sys.dyn.Z);

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
    
    params = sys.descrip.syms.';
    params_hat = add_symsuffix(sys.descrip.syms, '_hat').';

    fs_hat = subs(fs, params, params_hat);
    Ms_hat = subs(Ms, params, params_hat);
    
    min_params = params_lims(:, 1);
    max_params = params_lims(:, 2);
    
    params_num = min_params;
    params_hat_num = max_params;
    
    Fs = abs(fs - fs_hat);
    Fs_ = subs(Fs, [params, params_hat], ...
                   []);
    Fs_ = vpa(Fs);

    % Sliding gain
    K = diag(eta + Fs);
    
    % Sliding function
    error_a = q_a - q_a_d;
    errorp_a = qp_a - qp_a_d;
    
    error_u = q_u - q_u_d;
    errorp_u = qp_u - qp_u_d;
    
    s = alpha_a*errorp_a + lambda_a*error_a +...
        alpha_u*error_u + lambda_u*errorp_u;
    
    % Auxiliary function
    sr = -alpha_a*qp_a_d - alpha_u*qp_u_d +...
          lambda_a*error_a + lambda_u*error_u;
    
    sr_p = dvecdt(sr, [q; qp], [qp; qpp]);
    
    % Substituted values of numerical evalutation
    s = subs(s, params_hat, params_hat_num);
    sr_p = subs(sr_p, params_hat, params_hat_num);
    fs_hat = subs(fs, params_hat, params_hat_num);
    Ms_hat = subs(fs, params_hat, params_hat_num);
        
    u = -inv(Ms_hat)*(fs_hat + sr_p + K*sign(s));
end

