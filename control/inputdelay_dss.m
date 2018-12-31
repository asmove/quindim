function sys_ = inputdelay_dss(sys, nd)
    % Original matrices
    Phi = sys.a;
    Gamma = sys.b;
    C = sys.c;
    D = sys.d;
    
    ts = sys.ts;
    
    % Matrices sizes
    [n, ~] = size(Phi);
    [~, m] = size(Gamma);
    [p, ~] = size(C);
        
    % Augmented system
    if(nd == 1)
       Phi_aug = [Phi, zeros(n, nd*m); ...
                  zeros(m, n), zeros(m, nd*m)];
    else
       Phi_aug = [Phi, zeros(n, nd*m); ...
                  zeros(m, n), zeros(m, nd*m); ...
                  zeros((nd-1)*m, n), eye((nd-1)*m), zeros((nd-1)*m, m)];
    end
    
    Gamma_aug = [zeros(n, m); eye(m); zeros((nd - 1)*m, m)];
    
    C_aug = [C, zeros(p, nd*m)];
    D_aug = D;
        
    sys_ = ss(Phi_aug, Gamma_aug, C_aug, D_aug, ts);
end