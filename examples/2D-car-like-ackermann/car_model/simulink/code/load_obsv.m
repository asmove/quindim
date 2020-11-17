y = [theta, delta_i, delta_o, phi_i, phi_o, phi_r, phi_l];

% Inertia tensor inverse
A = sym('A_', size(sys.dyn.H));
[m, n] = size(A);

inv_A = inv(A);
H = sys.dyn.H;

A_reshaped = reshape(A, [m*n, 1]);
H_reshaped = reshape(H, [m*n, 1]);
inv_H  = subs(inv_A, A_reshaped, H_reshaped);

q = sys.kin.q;
p = sys.kin.p{end};
C = sys.kin.C;
h = sys.dyn.h;
Z = sys.dyn.Z;
u = sys.descrip.u;

n_q = length(q);
n_u = length(u);

plant = [C*p; inv_H*(-h + Z*u)];
f = [C*p; -inv_H*h];
G = [zeros(n_q, n_u); inv_H*Z];
x = [q; p];

reldeg_struct = nreldegs(f, G, y, x);

h1 = y(1);
h2 = y(2);
h3 = y(3);
h4 = y(4);
h5 = y(5);

jacobian(h1, x)*G
