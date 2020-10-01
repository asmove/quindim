% Unholonomic constraints

% Transformation and rotation matrices
Tci = Tc*Ti;
Rci = Tci(1:3, 1:3);

Tco = Tc*To;
Rco = Tco(1:3, 1:3);

Tcr = Tc*Tr;
Rcr = Tcr(1:3, 1:3);

Tcl = Tc*Tl;
Rcl = Tcl(1:3, 1:3);

% Wheel aliases
wheel_i = sys.descrip.bodies{2};
wheel_o = sys.descrip.bodies{3};
wheel_r = sys.descrip.bodies{4};
wheel_l = sys.descrip.bodies{5};

% Inner front wheel
v_cg_i = simplify_(wheel_i.v_cg);
[~, omega_i] = omega(Rci, qi, qpi);

v_contact_i = v_cg_i + cross(omega_i, Rci*[0; 0; -R]);
w_i = Rci*[0; 1; 0];
u_i = Rci*[1; 0; 0];

constraints_i = simplify_(dot(v_contact_i, u_i) - phip_i*R);

% Outer front wheel
v_cg_o = simplify_(wheel_o.v_cg);
[~, omega_o] = omega(Rco, qo, qpo);

v_contact_o = v_cg_o + cross(omega_o, Rco*[0; 0; -R]);
w_o = Rco*[0; 1; 0];
u_o = Rco*[1; 0; 0];

constraints_o = simplify_(dot(v_contact_o, u_o) - phip_o*R);

% Inner back wheel
v_cg_l = simplify_(wheel_l.v_cg);
[~, omega_l] = omega(Rcl, ql, qpl);

v_contact_l = v_cg_l + cross(omega_l, Rcl*[0; 0; -R]);
w_l = Rcl*[0; 1; 0];
u_l = Rcl*[1; 0; 0];

constraints_l = simplify_(dot(v_contact_l, u_l) - phip_l*R);

% Outer back wheel
v_cg_r = simplify_(wheel_r.v_cg);
[~, omega_r] = omega(Rcr, qr, qpr);

v_contact_r = v_cg_r + cross(omega_r, Rcr*[0; 0; -R]);
w_r = Rcr*[0; 1; 0];
u_r = Rcr*[1; 0; 0];

constraints_r = simplify_(dot(v_contact_r, u_r) - phip_r*R);

sys.descrip.unhol_constraints = {[constraints_i; constraints_o; constraints_r; constraints_l]};

% Holonomic constraints
sys.descrip.hol_constraints = {tan(delta_i) - tan(delta_o) - (w/L)*tan(delta_i)*tan(delta_o)};
