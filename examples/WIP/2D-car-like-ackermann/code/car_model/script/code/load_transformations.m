% Rotations to body
% Hypothesis: Symmetric car
Tc = T3d(theta, [0; 0; 1], [x_pos; y_pos; 0]);

Ti1 = T3d(delta_i, [0; 0; 1], [w/2; L; 0]);
Ti2 = T3d(phi_i, [0; 1; 0], [0; 0; 0]);

To1 = T3d(delta_o, [0; 0; 1], [-w/2; L; 0]);
To2 = T3d(phi_o, [0; 1; 0], [0; 0; 0]);

Tl1 = T3d(0, [0; 0; 1], [w/2; 0; 0]);
Tl2 = T3d(phi_l, [0; 1; 0], [0; 0; 0]);

Tr1 = T3d(0, [0; 0; 1], [-w/2; 0; 0]);
Tr2 = T3d(phi_r, [0; 1; 0], [0; 0; 0]);

Tcs = {Tc};
Tis = {Tc, Ti1, Ti2};
Tos = {Tc, To1, To2};
Trs = {Tc, Tr1, Tr2};
Tls = {Tc, Tl1, Tl2};

Ts = {{Tc}, {Tc, Ti1, Ti2}, {Tc, To1, To2}, {Tc, Tr1, Tr2}, {Tc, Tl1, Tl2}};

