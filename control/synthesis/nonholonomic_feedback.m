function u = nonholonomic_feedback(sys, s_q)
    q = sys.kin.q;
    p = sys.kin.p;

    if(length(sys.kin.C) ~= 1 && iscell(sys.kin.C))
        [m, ~] = size(sys.kin.C{1});
        
        Cs = eye(m);
        for i = 1:length(sys.kin.C)
            Cs = Cs*sys.kin.C{i};
        end
    else
        Cs = sys.kin.C;
    end
    
    if((length(p) ~= 1) && (iscell(sys.kin.C)))
        p = p{end};
    end

    [zeta, wn] = damp(poles_2);
    
    Zeta = diag(zeta); 
    Omega_n = diag(wn);
    
    K1 = 2*Zeta*Omega_n;
    K2 = Omega_n^2;
    
    ds_dq = jacobian(s_q, q);
    
    Z = sys.dyn.Z;
    H = sys.dyn.H;
    h = sys.dyn.h;
    
    v = -inv(ds_dq*Cs)*(jacobian(ds_dq*Cs*p)*Cs*p + K1*ds_dq*C*p + K2*s);
    u = inv(Z)*(h + H*v);
end