function sys_ = delaydss(sys, nd)
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
       Phi_aug = [Phi, zeros(n, nd*p); ...
                  C, zeros(p, nd*p)];
    else
       Phi_aug = [Phi, zeros(n, nd*p); ...
                  C, zeros(p, nd*p); ...
                  zeros((nd-1)*p, nd), eye((nd-1)*p), zeros((n-1)*p, p)];
    end
    
    Gamma_aug = [Gamma; zeros(nd*p, m)];
    C_aug = [zeros(p, n + (nd-1)*p), eye(p)];
    D_aug = D;
        
    sys_ = ss(Phi_aug, Gamma_aug, C_aug, D_aug, ts);
end