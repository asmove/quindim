[kappa_1, kappa_2, alpha_1, alpha_2, ...
 dkappa_1, dkappa_2, dalpha_1, dalpha_2] = sliding_coefficients(0);

assert(kappa_1 == 0);
assert(kappa_2 == 0);
assert(alpha_1 == 0);
assert(alpha_2 == 0);
assert(dkappa_1 == 0);
assert(dkappa_2 == 0);
assert(dalpha_1 == 0);
assert(dalpha_2 == 0);

u0 = [0;0;0;0];
x0 = [0;0;0;0;0;0;0;0;0;0;0;0];

qp0 = qp_vector(x0, kappa_1, kappa_2, alpha_1, alpha_2, ...
                Ii_11, Ii_21, Ii_22, Ii_31, Ii_32, Ii_33, ...
                Il_11, Il_21, Il_22, Il_31, Il_32, Il_33, ...
                Io_11, Io_21, Io_22, Io_31, Io_32, Io_33, ...
                Ir_11, Ir_21, Ir_22, Ir_31, Ir_32, Ir_33, ...
                Lc, mc, mi, ml, mo, mr, L, w);

n_zeros = zeros(9, 1);

assert(all(qp0 == n_zeros));

Q = Q_vector(x0, qp0, u0, kappa_1, kappa_2, alpha_1, alpha_2, ...
             Ii_11, Ii_21, Ii_22, Ii_31, Ii_32, Ii_33, ...
             Il_11, Il_21, Il_22, Il_31, Il_32, Il_33, ...
             Io_11, Io_21, Io_22, Io_31, Io_32, Io_33, ...
             Ir_11, Ir_21, Ir_22, Ir_31, Ir_32, Ir_33, ...
             Lc, mc, mi, ml, mo, mr, L, w);

assert(all(Q == n_zeros));

A_assert = [

         0         0         0    1.0000   -1.0000         0         0         0         0;
         0         0         0         0         0         0         0   -1.0000    1.0000;
    1.0000         0   -4.5000         0         0   -0.3442         0         0         0;
         0    1.0000    0.7500         0         0         0         0         0         0;
    1.0000         0   -4.5000         0         0         0   -0.3442         0         0;
         0    1.0000   -0.7500         0         0         0         0         0         0];

A_1delta = A_matrix(x0, kappa_1, kappa_2, alpha_1, alpha_2, w, L, R);

assert(sum(sum(abs(abs(A_1delta) - abs(A_assert)))) < 1e-4);

C_assert = [0    0.3442         0;
            0         0         0;
            0         0         0;
       1.0000         0         0;
       1.0000         0         0;
            0    1.0000         0;
            0    1.0000         0;
            0         0    1.0000;
            0         0    1.0000];

C_1delta = C_matrix(x0, kappa_1, kappa_2, alpha_1, alpha_2, L, R, w);

assert(sum(sum(abs(abs(C_1delta) - abs(C_assert)))) < 1e-4);

dA_1delta = Ap_matrix(x0, kappa_1, kappa_2, alpha_1, alpha_2, w, L, R);

dA_assert = [
         0         0         0    1.0000   -1.0000         0         0         0         0;
         0         0         0         0         0         0         0   -1.0000    1.0000;
    1.0000         0   -4.5000         0         0   -0.3442         0         0         0;
         0    1.0000    0.7500         0         0         0         0         0         0;
    1.0000         0   -4.5000         0         0         0   -0.3442         0         0;
         0    1.0000   -0.7500         0         0         0         0         0         0];

assert(sum(sum(abs(abs(dA_assert) - abs(dA_1delta)))) < 1e-4);

dC_1delta = Cp_matrix(x0, qp0, kappa_1, kappa_2, alpha_1, alpha_2, ...
                      dkappa_1, dkappa_2, dalpha_1, dalpha_2, w, L, R);

dC_assert = zeros(length(sys.kin.q), ...
                  length(sys.kin.p{end}));

assert(sum(sum(abs(abs(dC_assert) - abs(dC_1delta)))) < 1e-4);

M = M_matrix(x0, ...
             Io_32, Io_33,...
             Ir_11, Ir_21, Ir_22, Ir_31, Ir_32, Ic_33, ...
             Ii_11, Ii_21, Ii_22, Ii_31, Ii_32, Ii_33,...
             Il_11, Il_21, Il_22, Il_31, Il_32, Il_33,...
             Io_11, Io_21, Io_22, Io_31, Ir_33,...
             L, Lc, mc, mi, ml, mo, mr, w);

M_assert = [
    1.88500000000000e+003		0.00000000000000e+000	-4.24125000000000e+003	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000;
    0.00000000000000e+000		1.88500000000000e+003	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000;
    -4.24125000000000e+003		0.00000000000000e+000	13.1838465762470e+003	414.769061750540e-003	414.769061750540e-003	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000;
    0.00000000000000e+000		0.00000000000000e+000	414.769061750540e-003	414.769061750540e-003	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000;
    0.00000000000000e+000		0.00000000000000e+000	414.769061750540e-003	0.00000000000000e+000	414.769061750540e-003	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000;
    0.00000000000000e+000		0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	207.384530875270e-003	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000;
    0.00000000000000e+000		0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	207.384530875270e-003	0.00000000000000e+000	0.00000000000000e+000;
    0.00000000000000e+000		0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	207.384530875270e-003	0.00000000000000e+000;
    0.00000000000000e+000		0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	0.00000000000000e+000	207.384530875270e-003];

assert(sum(sum(abs(abs(M_assert) - abs(M)))) < 1e-4);

H = H_matrix(C_assert, M_assert);

H_assert = [
    0.82953812350108         0                  0
    0                      223.737580461751     0
    0                         0                 0.41476906175054];

assert(sum(sum(abs(abs(H_assert) - abs(H)))) < 1e-4);

q0 = x0(1:9);
p0 = x0(10:12);

C_fric = friction_vector(q0, p0, kappa_1, kappa_2, alpha_1, alpha_2, C_1delta, mc, mi, g, a, Cp_1, mu_1, Fz_1, Cp_2, mu_2, Fz_2);

sqrt_M = sqrtm(M_assert);
inv_M = inv(M_assert);
M_12 = inv(sqrt_M);

[f, f_i, f_ni] = fs_vectors(q0, p0, C_fric, M_assert, sqrt_M, inv_M, M_12, Q, A_1delta, dA_1delta, C_1delta, dC_1delta);

assert(sum(sum(abs(abs(f) - abs([0;0;0])))) < 1e-4);
assert(sum(sum(abs(abs(f_i) - abs([0;0;0])))) < 1e-4);
assert(sum(sum(abs(abs(f_ni) - abs([0;0;0])))) < 1e-4);

f_i_ni = f + f_i + f_ni;

inv_H = inv(H);

dq = plant_vector(q0, p0, f_i_ni, C_1delta, inv_H);

n_q_p = length(sys.kin.q) + length(sys.kin.p{end});
assert(sum(sum(abs(abs(dq) - abs(zeros(n_q_p, 1))))) < 1e-4);
