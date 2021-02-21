[~, m] = size(B);
[n_Ctilde, ~] = size(Ctilde);
[n_C, ~] = size(C);

[~, m] = size(sysd.B);
n = length(Phi);

% Augment system
Phi_aug = double([Phi, zeros(n, n_Ctilde);...
                  -Ctilde, eye(n_Ctilde)]);

Gamma_aug = double([Gamma;...
                    zeros(n_Ctilde, m)]);

C_aug = double([C, zeros(n_C, n_Ctilde)]);

D_aug = double(D);

sysd_aug = ss(Phi_aug, Gamma_aug, C_aug, D_aug, Ts_val);

Phi_aug = double(Phi_aug);
Gamma_aug = double(Gamma_aug);
C_aug = double(C_aug);

n_aug = length(Phi_aug);

% Project poles 
p_0 = -15;
p_c_k = p_0;
n_aug = length(Phi_aug);

for i = 2:n_aug
    p_i = p_0 - i*5;
    p_c_k(i) = p_i;
end

p_d_k = exp(Ts_val*p_c_k);

% Controller project
K_aug = acker(Phi_aug, Gamma_aug, p_d_k);

params.Kp = K_aug(:, 1:n_aug-1);
params.Ki = -K_aug(:, n_aug);
