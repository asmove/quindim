B_pwm = double(subs(B_sym*Vcc, symbs, vals));

sys = ss(A, B_pwm, C, D);
sysd = c2d(sys, Ts_val);

Phi = sysd.a;
Gamma = sysd.b;
C = sysd.c;
D = sysd.d;