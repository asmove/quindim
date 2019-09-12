function [s, sr, sr_p] = s_sr_srp(sys, alpha_a, alpha_u, lambda_a, lambda_u)
    [n, m] = size(sys.dyn.Z);

    % Generalized coordinates, velocities and accelerations
    q = sys.kin.q;
    p = sys.kin.p;
    pp = sys.kin.pp;
    
    % Actuated and unactuated systems
    q_a = q(1:m);
    q_u = q(m+1:end);

    qp_a = p(1:m);
    qp_u = p(m+1:end);

    qpp_a = pp(1:m);
    qpp_u = pp(m+1:end);
    
    q_a_d = add_symsuffix(q_a, '_d');
    qp_a_d = add_symsuffix(qp_a, '_d');
    qpp_a_d = add_symsuffix(qpp_a, '_d');

    q_u_d = add_symsuffix(q_u, '_d');
    qp_u_d = add_symsuffix(qp_u, '_d');
    qpp_u_d = add_symsuffix(qpp_u, '_d');
    
    % Sliding function
    error_a = q_a - q_a_d;
    errorp_a = qp_a - qp_a_d;
    
    error_u = q_u - q_u_d;
    errorp_u = qp_u - qp_u_d;
    
    if(m == n)
        s = alpha_a*errorp_a + lambda_a*error_a;
                
        % Auxiliary variable
        sr = -alpha_a*qp_a_d + lambda_a*error_a ;
    elseif(m < n)
        s = alpha_a*errorp_a + lambda_a*error_a +...
        alpha_u*error_u + lambda_u*errorp_u;
    
        % Auxiliary variable
        sr = -alpha_a*qp_a_d - alpha_u*qp_u_d +...
              lambda_a*error_a + lambda_u*error_u; 
    else
        error('Overactuated systems are not implemented!')
    end
    
    qp = sys.kin.C*p;
    sr_p = dvecdt(sr, [q; p; q_a_d; q_u_d; qp_a_d; qp_u_d], ...
                      [qp; pp; qp_a_d; qp_u_d; ....
                       qpp_a_d; qpp_u_d]);
end