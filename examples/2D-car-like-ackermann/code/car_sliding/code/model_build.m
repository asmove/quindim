run('~/github/Robotics4fun/examples/2D-car-like-ackermann/code/main.m');

% Symbolic variables
syms mu_ a_0 a_1 v_0 v_1;
syms mu_v_c1 mu_v_c2 mu_v_c3 mu_v_c4

syms Fa(v) Ta1(w) Ta2(w)
syms sign_sym(a)

syms omega_s v_s
syms kappa_1 kappa_2 kappa_3 kappa_4
syms dkappa_1 dkappa_2 dkappa_3 dkappa_4

sign_sym(a) = sign(a);

% States and speeds
pp = sys.kin.pp{end};
p = sys.kin.p{end};
q = sys.kin.q;
qp = sys.kin.qp;

% Accelerations
pp1 = pp(1);
pp2 = pp(2);
pp3 = pp(3);
pp4 = pp(4);

% Quasi-velocities
p1 = p(1);
p2 = p(2);
p3 = p(3);
p4 = p(4);

% States derivatives
xp = qp(1);
yp = qp(2);
thetap = qp(3);
deltap_i = qp(4);
deltap_o = qp(5);
phip_i = qp(6);
phip_o = qp(7);
phip_r = qp(8);
phip_l = qp(9);

run('./udwadia_declaration.m');

qp = sys.kin.qp;
H = C_1delta.'*M*C_1delta;
f = subs(C_1delta.'*Q, qp, C_1delta*p);
f_i = subs(-C_1delta.'*M*dC_1delta*p + C_1delta.'*Qc_i, qp, C_1delta*p);
C_Wc = subs(C_1delta.'*Wc, qp, C_1delta*p);
C_Wc = subs(C_Wc, [abs(sys.descrip.syms), abs(kappa), abs(alpha)], ...
                  [sys.descrip.syms, kappa, alpha]);
f_ni = C_Wc*C_fric;

model.H = H;
model.f = f;
model.f_i = f_i;
model.f_ni = f_ni;

model.q = q;
model.p = p;

model.plant = [C_1delta*p; inv(H)*(f + f_i + f_ni)];
model.plant = subs(model.plant, ...
                   sys.descrip.syms, ...
                   sys.descrip.model_params);

