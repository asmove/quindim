function u = sliding_underactuated(sys)
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
    M = -sys.dyn.H;

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
    
    params = sys.descrip.syms.';
    params_hat = add_symsuffix(sys.descrip.syms, '_hat').';

    fs_hat = subs(fs, params, params_hat);
    Ms_hat = subs(Ms, params, params_hat);
    
    Fs = abs(fs - fs_hat);
    
    eta = sym('eta');
    
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
    
    u.output = -inv(Ms_hat)*(fs_hat + sr_p + K*sign(s));
    u.Ms = Ms;
    u.lambda = [lambda_a, lambda_u];
    u.alpha = [alpha_a, alpha_u];
    u.Fs = Fs;
    u.fs = fs;
    u.fs_hat = fs_hat;
    u.params = params;
    u.params_hat = params_hat;
    u.eta = eta;
end

