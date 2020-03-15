function [s, sr, sr_p] = s_sr_srp(sys, , is_int)
    [n, m] = size(sys.dyn.Z);
    
    % Generalized coordinates, velocities and accelerations
    q = sys.kin.q;
    p = sys.kin.p;
    pp = sys.kin.pp;
    r = sym('r', size(q));
    
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
    
    p = p{end};
    pp = pp{end};
    
    qp = Cs*p;
    qpp = Cp*p + Cs*pp;
    
    % Actuated and unactuated systems
    q_d = add_symsuffix(r_d, '_d');
    p_d = add_symsuffix(p, '_d');
    pp_d = add_symsuffix(pp, '_d');
    
    q_a_d = add_symsuffix(q_a, '_d');
    qp_a_d = subs(qp_a, [q; p], [q_d; p_d]);
    qpp_a_d = subs(qpp_a, [q; p; pp], [q_d; p_d; pp_d]);

    q_u_d = add_symsuffix(q_u, '_d');
    qp_u_d = subs(qp_u, [q; p], [q_d; p_d]);
    qpp_u_d = subs(qpp_u, [q; p; pp], [q_d; p_d; pp_d]);

    q_d = [q_a_d; q_u_d];
    qp_d = [qp_a_d; qp_u_d];
    qpp_d = [qpp_a_d; qpp_u_d];
    
    if(is_int)
        r_d = add_symsuffix(r, '_d');
        rp_d = q_d;
    end
    
    % Sliding function
    int_error_ = q_a - q_a_d;
    error_ = q_a - q_a_d;
    errorp_ = qp_a - qp_a_d;
    
    error_u = q_u - q_u_d;
    errorp_u = qp_u - qp_u_d;
    
    if(~is_int)
        if(m == n)
            s = alpha_a*errorp_a + lambda_a*error_a;

            % Auxiliary variable
            sr = -alpha_a*qp_a_d + lambda_a*error_a;
            
        elseif(m < n)
            s = alpha_a*errorp_a + alpha_u*errorp_u + ...
                lambda_a*error_a + lambda_u*error_u;

            % Auxiliary variable
            sr = -alpha_a*qp_a_d - alpha_u*qp_u_d +...
                  lambda_a*error_a + lambda_u*error_u; 
        else
            error('Overactuated systems are not implemented!')
        end
    else
        if(m == n)
            s = alpha_a*errorp_a + lambda_a*error_a;

            % Auxiliary variable
            sr = -alpha_a*qp_a_d + lambda_a*error_a;
        
        elseif(m < n)
            s = alpha_a*errorp_a + alpha_u*errorp_u + ...
                lambda_a*error_a + lambda_u*error_u;

            % Auxiliary variable
            sr = -alpha_a*qp_a_d - alpha_u*qp_u_d +...
                  lambda_a*error_a + lambda_u*error_u; 
        else
            error('Overactuated systems are not implemented!')
        end
    end
    
    if(length(sys.kin.C) ~= 1) && (iscell(sys.kin.C))
        [m, ~] = size(sys.kin.C{1});
        
        C = eye(m);
        for i = 1:length(sys.kin.C)
            C = C*sys.kin.Cs{i};
        end
    else
        C = sys.kin.C;
    end
    
    Cp = sys.kin.Cp;
    
    qp = C*p;
    qpp = Cp*p + C*pp;
    
    q_p = [q; p; q_d; qp_d];
    qp_pp = [qp; pp; qp_d; qpp_d];
    
    sr_p = dvecdt(sr, q_p, qp_pp);
    
    % Struct construction
    s_struct.s = s;
    s_struct.sr = sr;
    s_struct.sr_p = sr_p;
    
end
