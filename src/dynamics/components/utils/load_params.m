syms J b R L k_i k_w n Vcc real
syms th thp curr u real

symbs = [J b R L k_i k_w n Vcc];

% J thpp = - b thp + k_i i
% 0      = u_pwm - k_w thp - R i

thpp_eq = (-b/J)*thp + (k_i/J)*curr;
ip_eq = (u - k_w*thp - R*curr)/L;

eqs = [thpp_eq; ip_eq];

y_eq = [thp; curr];
ytilde_eq = n*k_i*curr;

states = [thp; curr];

A_sym = equationsToMatrix(eqs, states);
B_sym = equationsToMatrix(eqs, u);
C_sym = equationsToMatrix(y_eq, states);
Ctilde_sym = equationsToMatrix(ytilde_eq, states);
D_sym = equationsToMatrix(y_eq, u);

% Common collector voltage [V]
Vcc_val = 12;

% Rotor inertia [kg m^3]
J_val = 0.02;

% Viscuous parameter
b_val = 0.2;

% Resistance value
R_val = 2;

% Inductance [H]
L_val = 0.5;

% Current motor constant 
k_i_val = 0.1;

% Speed motor constant [V.s/rad]
k_w_val = 0.1;

% Gear ratio
n_val = 50;

vals = [J_val b_val R_val L_val ...
        k_i_val k_w_val n_val Vcc_val];

% State space representation
A = double(subs(A_sym, symbs, vals));
B = double(subs(B_sym, symbs, vals));
C = double(subs(C_sym, symbs, vals));
Ctilde = double(subs(Ctilde_sym, symbs, vals));
D = double(subs(D_sym, symbs, vals));

C_ = C;

s = tf('s');

n = length(A_sym);

c_torque = C(1, :);
G = c_torque*inv(s*eye(n) - A)*B;

% Voltage levels [V]
u_num = [-Vcc; Vcc];

% Duty cycle [%/100]
alpha_ref = 0.25;

% PWM and sampling periods
Tpwm_val = 1e-3;
Ts_val = 1e-2;

% Final time
t_f = 0.5;

% Stationary values
syms alpha_ Tpwm Ts real;

A_rl = A_sym;
B_rl = B_sym;

alpha_ss = 1;
beta_ss = 1-alpha_ss;

u_mean = alpha_ref*Vcc_val;

x_ss = double(subs(-inv(A_rl)*B_rl*u_mean, symbs, vals));
w_ss = x_ss(1);

% Stationary values
i_ref = (1/R_val)*(u_mean - k_w_val*w_ss);
torque_ref = n_val*k_i_val*i_ref;
