function s_struct = s_sr_srp(sys, refdyn_str, ...
                             is_int, is_dyn_bound)
    [n, m] = size(sys.dyn.Z);
    
    alpha_ = refdyn_str.alpha;
    lambda_ = refdyn_str.lambda;
    
    if(is_int)
        mu_ = refdyn_str.mu;
    end
    
    alpha_a = alpha_(:, 1:m);
    alpha_u = alpha_(:, m+1:end);
    lambda_a = lambda_(:, 1:m);
    lambda_u = lambda_(:, m+1:end);
    
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
    q_d = add_symsuffix(q, '_d');
    qp_d = add_symsuffix(qp, '_d');
    qpp_d = add_symsuffix(qpp, '_d');
    
    p_d = add_symsuffix(p, '_d');
    pp_d = add_symsuffix(pp, '_d');
    
    if(is_int)
        r_d = add_symsuffix(r, '_d');
        rp_d = q_d;
    end
    
    % Sliding function
    error_ = q - q_d;
    errorp_ = qp - qp_d;
    
    if(is_dyn_bound)
        w = sym('w', [m, 1]);
    end
    
    if(is_int)
        r = sym('r', size(sys.kin.q));
        r_d = add_symsuffix(r, '_d');
        
        int_error_ = r - r_d;
        
        s = alpha_*errorp_ + lambda_*error_ + mu_*int_error_;
        sr = -alpha_*qp_d + lambda_*error_ + mu_*int_error_;
        
        
    else
        s = alpha_*errorp_ + lambda_*error_;
        sr = -alpha_*qp_d + lambda_*error_;
    end
    
    q_qp = [q; qp];
    qd_qpd = [q_d; qp_d; qpp_d];
    
    if(is_int)
        if(is_dyn_bound)
            symvars = [q_qp; r; w; r_d; qd_qpd];
        else
            symvars = [q_qp; r; r_d; qd_qpd];
        end
    else
        symvars = [q_qp; qd_qpd];
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
    
    if(is_int)
        vars = [r; q; qp; r_d; q_d; qp_d];
        dvars = [q; qp; qpp; q_d; qp_d; qpp_d];
    else
        vars = [q; qp; q_d; qp_d];
        dvars = [qp; qpp; qp_d; qpp_d];
    end
    
    sr_p = dvecdt(sr, vars, dvars);
    
    % Struct construction
    s_struct.s = s;
    s_struct.sr = sr;
    s_struct.sr_p = sr_p;
    s_struct.symvars = symvars;
    s_struct.int_q = q;
end
