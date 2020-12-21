function [t, tf, q, qp, qpp] = P2P(P0, P1, A_max, delta)
    
    if(nargin == 3)
        delta = 0.25;
    end

    if((delta > 1) || (delta < 0))
       error('alpha MUST be between 0 and 1!'); 
    end
    
    n_versor = (P1-P0)/norm(P1-P0);
    beta = (1 - delta)/2;
    
    % End time [s]
    t0 = sqrt((2/A_max)*pinv(n_versor)*(beta*(P1 - P0)));
    
    v0 = A_max*n_versor*t0;
    t1 = pinv(v0)*delta*(P1 - P0);  
    tf = 2*t0 + t1;
    
    % Time vector
    n = 100;
    t_ = linspace(0, tf, n);
    
    q = [];
    qp = [];
    qpp = [];
    for t = t_
        if(t < t0)
            t_ = 0;
            a0 = A_max*n_versor;
            V0 = 0*n_versor;
            S0 = P0;
            
        elseif((t >= t0) && (t <= t0 + t1))
            t_ = t0;
            a0 = 0*n_versor;
            V0 = A_max*n_versor*t0;
            S0 = P0 + beta*(P1 - P0);

        else
            t_ = t0 + t1;
            a0 = -A_max*n_versor;
            V0 = A_max*n_versor*t0;
            S0 = P0 + (delta + beta)*(P1 - P0);
        end

        S = a0*(t - t_)^2/2 + V0*(t - t_) + S0;
        V = a0*(t - t_) + V0;
        A = a0;
        
        q = [q; S.'];
        qp = [qp; V.'];
        qpp = [qpp; A.'];
    end
    
    t = linspace(0, tf, n).';
end
