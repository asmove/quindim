% Sliding deviation in velocity
v_01 = sqrt(v_0^2 + v_1^2);

Fa_1(v) = mu_v_c1*(mi + mc/4)*g*sign_sym(v);
Fa_2(v) = mu_v_c2*(mo +  + mc/4)*g*sign_sym(v);
Fa_3(v) = mu_v_c3*(mr +  + mc/4)*g*sign_sym(v);
Fa_4(v) = mu_v_c4*(ml +  + mc/4)*g*sign_sym(v);

U = sys.dyn.U;
u = sys.descrip.u;

nu = sys.dyn.nu;
g_ = sys.dyn.g;
f_b = sys.dyn.f_b;
f_k = sys.dyn.f_k;

% Constraints and virtual displacements
delta = [0;
         -kappa_1*(xp*cos(theta) + yp*sin(theta));
         -kappa_2*(xp*cos(theta) + yp*sin(theta)); 
         -kappa_3*(xp*cos(theta) + yp*sin(theta)); 
         -kappa_4*(xp*cos(theta) + yp*sin(theta))];

Alpha = equationsToMatrix(delta, sys.kin.qp);

A = sys.kin.A;
A_1 = A;
A_delta = -Alpha;
A_1delta = A + A_delta;

C_1 = null(A_1);
C_delta = null(A_1delta) - null(A_1);
C_1delta = C_1 + C_delta;

dC_1 = dmatdt(C_1, [q; kappa_1; kappa_2; kappa_3; kappa_4], ...
                   [C_1delta*p; dkappa_1; dkappa_2; dkappa_3; dkappa_4]);
dC_delta = dmatdt(C_delta, [q; kappa_1; kappa_2; kappa_3; kappa_4], ...
                           [C_1delta*p; dkappa_1; dkappa_2; dkappa_3; dkappa_4]);
dC_1delta = dmatdt(C_1delta, [q; kappa_1; kappa_2; kappa_3; kappa_4], ...
                             [C_1delta*p; dkappa_1; dkappa_2; dkappa_3; dkappa_4]);

% Constraints derivatives
Ap_1 = dmatdt(A_1, [q; kappa_1; kappa_2; kappa_3; kappa_4], ...
                   [C_1delta*p; dkappa_1; dkappa_2; dkappa_3; dkappa_4]);
Ap_delta = dmatdt(A_delta, [q; kappa_1; kappa_2; kappa_3; kappa_4], ...
                           [C_1delta*p; dkappa_1; dkappa_2; dkappa_3; dkappa_4]);
Ap_1delta = dmatdt(A_1delta, [q; kappa_1; kappa_2; kappa_3; kappa_4], ...
                             [C_1delta*p; dkappa_1; dkappa_2; dkappa_3; dkappa_4]);

b_1 = -Ap_1*C_1*p;
b_delta = -Ap_1*C_delta*p + Ap_delta*C_1delta*p;
b_1delta = b_1 + b_delta;

% Unconstrained forces
Q = U*u-nu-g_-f_b-f_k;

% Useful constraint
M = sys.dyn.M;
M_12 = simplify_(inv(sqrt(M)));

B_1 = simplify(A_1*M_12);
B_delta = simplify(A_delta*M_12);
B_1delta = simplify(A_1delta*M_12);

pB_1 = pinv(B_1);
pB_delta = pinv(B_delta);
pB_1delta = pinv(B_1delta);

n = length(pB_1);
Wc = eye(n) - pB_1delta*B_1delta;

% ideal constraint
Q = [Q; 0; 0];
a = inv(M)*Q;
Qc_i = sqrt(M)*pB_1delta*(b_1delta - A_1delta*a);

v_vers = [[cos(theta); sin(theta)]; zeros(length(sys.kin.q)-2, 1)];

R_th = rot2d(theta);
Ci_fric = -blkdiag(R_th*v_vers*Fa(norm(kappa_1*v_i)));
Co_fric = -blkdiag(R_th*v_vers*Fa(norm(kappa*v_o)));
Cr_fric = -blkdiag(R_th*v_vers*Fa(norm(kappa*v_r)));
Cl_fric = -blkdiag(R_th*v_vers*Fa(norm(kappa*v_l)));

F = sqrt(M)*Wc/sqrt(M);
Qc_ni = F*C_fric;

Q_sum = Q + Qc_i + Qc_ni;
Q_sum = simplify_(Q_sum);