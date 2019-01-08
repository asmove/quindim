function [t, tf, q, qp, qpp] = P2P(P0, P1, A_max)
    n_versor = (P1-P0)/norm(P1-P0);

    % End time [s]
    tf = 2*sqrt((1/A_max)*pinv(n_versor)*(P1-P0));
    
    % Time vector
    n = 100;
    t_ = linspace(0, tf, n);
    t = linspace(0, tf, n).';
    
    dt = t(2) - t(1);
    
    q = [];
    qp = [];
    qpp = [];
    
    for i = t_
        if(i/tf < 0.5)
            t0 = 0;
            a0 = A_max;
            V0 = 0;
            S0 = P0;
        else
            t0 = 0.5*tf;
            a0 = -A_max;
            V0 = A_max*n_versor*0.5*tf;
            S0 = A_max*n_versor*(0.5*tf)^2/2 + P0;
        end
        
        S = a0*n_versor*(i - t0)^2/2 + V0*(i - t0) + S0;
        V = a0*n_versor*(i - t0) + V0;
        A = a0*n_versor;
        
        q = [q; [S.', 0]];
        qp = [qp; [V.', 0]];
        qpp = [qpp; [A.', 0]];
    end
end