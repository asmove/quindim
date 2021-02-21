B_pwm = double(subs(B_sym*Vcc, symbs, vals));

sys = ss(A, B_pwm, C_, D);
sysd = c2d(sys, Ts_val);

Phi = sysd.a;
Gamma = sysd.b;
C = sysd.c;
D = sysd.d;

% Observer
% Project poles 
p_0 = -25;
p_c_l = p_0;
n = length(Phi);

for i = 2:n
    p_i = p_0 - i*5;
    p_c_l(i) = p_i;
end

p_d_l = exp(Ts_val*p_c_l);

L = place(Phi', C', p_d_l)';
params.L = L;

params.Phi = Phi;
params.Gamma = Gamma;
params.C = C;
