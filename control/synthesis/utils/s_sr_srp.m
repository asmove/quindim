function [s, sr, sr_p] = s_sr_srp(sys, alpha_a, alpha_u, lambda_a, lambda_u)
    [n, m] = size(sys.dyn.Z);

    % Generalized coordinates, velocities and accelerations
    q = sys.kin.q;
    p = sys.kin.p;
    pp = sys.kin.pp;
    
    if((length(sys.kin.C) ~= 1) && (iscell(sys.kin.C)))
        [a, ~] = size(sys.kin.C{1});
        
        Cs = eye(a);
        for i = 1:length(sys.kin.C)
            Cs = Cs*sys.kin.C{i};
        end
    else
        Cs = sys.kin.C;
    end
    
    Cp = sys.kin.Cp;
    
    if((length(p) ~= 1) && (iscell(sys.kin.C)))
        p = p{end};
        pp = pp{end};
    end
    
    qp = Cs*p;
    qpp = Cp*p + Cs*pp;
    
    % Actuated and unactuated systems
    q_a = q(1:m);
    q_u = q(m+1:end);
    
    qp_a = qp(1:m);
    qp_u = qp(m+1:end);

    qpp_a = qpp(1:m);
    qpp_u = qpp(m+1:end);
    
    q_d = add_symsuffix(q, '_d');
    p_d = add_symsuffix(p, '_d');
    pp_d = add_symsuffix(pp, '_d');
    
    q_a_d = add_symsuffix(q_a, '_d');
    qp_a_d = subs(qp_a, [q; p], [q_d; p_d]);
    qpp_a_d = subs(qpp_a, [q; p; pp], [q_d; p_d; pp_d]);

    q_u_d = add_symsuffix(q_u, '_d');
    qp_u_d = subs(qp_u, [q; p], [q_d; p_d]);
    qpp_u_d = subs(qpp_u, [q; p; pp], [q_d; p_d; pp_d]);
    
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
    
    if(length(sys.kin.C) ~= 1) && (iscell(sys.kin.C))
        [m, ~] = size(sys.kin.C{1});
        
        C = eye(m);
        for i = 1:length(sys.kin.C)
            C = C*sys.kin.C{i};
        end
    else
        C = sys.kin.C;
    end
    
    Cp = sys.kin.Cp;
    
    qp = C*p;
    qpp = Cp*p + C*pp;
    
    q_p = [q; p];
    qp_pp = [qp; pp];
    
    sr_p = dvecdt(sr, q_p, qp_pp);
end