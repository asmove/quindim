y = [delta_o, phi_o, phi_r, phi_l];

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
x = [q; p];

n_q = length(q);
n_u = length(u);

plant = [C*p; inv_H*(-h + Z*u)];
f = [C*p; -inv_H*h];
G = [zeros(n_q, n_u); inv_H*Z];
x = [q; p];

% reldeg_struct = nreldegs(f, G, y, x);
Lf_hs = {};
LG_hs = {};

for i = 1:length(y)
    Lf_hs{i} = y(i);
end

for i = 1:length(y)
    L_f_g = lie_diff(f, g, x);
    
    Lf_hs_i = Lf_hs{i};
    Lh_j = Lf_hs_i(1);
    j = 1;
    
    while(isempty(symvar(lie_diff(G, Lh_j, x))))
        Lf_h_j1 = simplify_(lie_diff(f, Lh_j, x));
        LG_h_j1 = simplify_(lie_diff(G, Lh_j, x));
        
        Lf_hs_i = [Lf_hs_i; Lf_h_j1];
        Lh_j = Lf_h_j1;
        j = j + 1;
    end
    
    LG_hs{i} = lie_diff(G, Lf_h_j1, x);
    Lf_hs{i} = Lf_hs_i;
end

LG_h = [];
for i = 1:length(LG_hs)
    LG_h = [LG_h; LG_hs{i}];
end




