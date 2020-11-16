syms kappa_i kappa_o kappa_r kappa_l real;
syms dkappa_i dkappa_o dkappa_r dkappa_l real;
syms alpha_i alpha_o alpha_r alpha_l real;
syms dalpha_i dalpha_o dalpha_r dalpha_l real;

R = sys.descrip.syms(end-4);
R_1 = L*cot_delta;
R_ = sqrt(R_1^2 + Lc^2);

% Holonomic constraints - Inner and outer angles
sys.descrip.hol_constraints = {tan(delta_i) - tan(delta_o) - (w/L)*tan(delta_i)*tan(delta_o)};

% Unholonomic constraints
cot_delta = (1/tan(delta_o) + 1/tan(delta_i))/2;
delta = acot(cot_delta);

radius_i = (cos(alpha_l)/(sin(delta_i - alpha_i + alpha_l)))*L;
radius_l = (cos(delta_i - alpha_i)/sin(delta_i - alpha_i + alpha_l))*L;

h = radius_i*cos(delta_i - alpha_l);
ell_1 = radius_i*sin(alpha_l);
ell_2 = L - ell_1;

radius_r = ell_1*cos(alpha_r);
radius_o = ell_2*sec(delta_o + alpha_l);

% Transformation and rotation matrices
Rc = simplify(Tc(1:3, 1:3));

Tci = Tc*Ti1;
Rci = simplify_(Tci(1:3, 1:3));
Rphi_i = rot3d(phi_i, [0; 1; 0]);
Rci = Rci*Rphi_i;

Tcl = Tc*Tl1;
Rcl = simplify_(Tcl(1:3, 1:3));
Rphi_l = rot3d(phi_l, [0; 1; 0]);
Rcl = Rci*Rphi_l;

Tco = Tc*To1;
Rco = simplify_(Tco(1:3, 1:3));
Rphi_o = rot3d(phi_o, [0; -1; 0]);
Rco = Rci*Rphi_o;

Tcr = Tc*Tr1;
Rcr = simplify_(Tcr(1:3, 1:3));
Rphi_r = rot3d(phi_r, [0; -1; 0]);
Rcr = Rci*Rphi_r;

Ri_s = rot3d(theta + delta_i - alpha_i, [0; 0; 1]);
Ro_s = rot3d(theta + delta_o - alpha_o, [0; 0; 1]);
Rr_s = rot3d(theta - alpha_r, [0; 0; 1]);
Rl_s = rot3d(theta - alpha_l, [0; 0; 1]);

% Wheel aliases
chassi = sys.descrip.bodies{1};
wheel_i = sys.descrip.bodies{2};
wheel_o = sys.descrip.bodies{3};
wheel_r = sys.descrip.bodies{4};
wheel_l = sys.descrip.bodies{5};

% Inner front wheel
omega_c = omega(Rc, sys.kin.q, sys.kin.qp);
[~, omega_i] = omega(Rci, qi, qpi);
v_cg_i = [xp; yp; 0] + cross(omega_c, Rc*[w/2; L; 0]);

v_contact_i = v_cg_i + cross(omega_i, Rci*[0; 0; -R]);

u_i = Rci*[1; 0; 0];
w_i = Rci*[0; 1; 0];

v_i = simplify(dot(v_contact_i, u_i));
v_i_perp = simplify(dot(v_contact_i, w_i));

u_is = Ri_s*[1; 0; 0];
w_is = Ri_s*[0; 1; 0];

v_i_s = -[kappa_i; kappa_i*tan(alpha_i); 0]*phip_i*R;
v_i_s_center = v_i_s + cross(omega_i, Ri_s*[0; 0; R]);

proj_vis_center = simplify_(dot(v_i_s_center, u_is));

constraints_i = [simplify_(v_i - phip_i*R); simplify(v_i_perp)];

% % Outer front wheel
[~, omega_o] = omega(Rco, qo, qpo);
v_cg_o = [xp; yp; 0] + cross(omega_c, Rc*[-w/2; L; 0]);

v_contact_o = v_cg_o + cross(omega_o, Rco*[0; 0; -R]);
u_o = Rco*[1; 0; 0];
w_o = Rco*[0; 1; 0];

v_o = simplify(dot(v_contact_o, u_o));
v_o_perp = simplify(dot(v_contact_o, w_o));

u_os = Ro_s*[1; 0; 0];
w_os = Ro_s*[0; 1; 0];

v_o_s = -[kappa_o; kappa_o*tan(alpha_o); 0]*phip_o*R;
v_o_s_center = v_o_s + cross(omega_o, Ro_s*[0; 0; R]);

proj_vos_center = simplify_(dot(v_o_s_center, u_os));

% Inner back wheel
[~, omega_l] = omega(Rcl, ql, qpl);
v_cg_l = [xp; yp; 0] + cross(omega_c, Rc*[w/2; 0; 0]);

v_contact_l = v_cg_l + cross(omega_l, Rcl*[0; 0; -R]);

u_l = Rcl*[1; 0; 0];
w_l = Rcl*[0; 1; 0];

v_l = simplify(dot(v_contact_l, u_l));
v_l_perp = simplify(dot(v_contact_l, w_l));

u_ls = Rl_s*[1; 0; 0];
w_ls = Rl_s*[0; 1; 0];

v_l_s = -[kappa_l; kappa_l*tan(alpha_l); 0]*phip_l*R;
v_l_s_center = v_l_s + cross(omega_l, Rl_s*[0; 0; R]);

proj_vls_center = simplify_(dot(v_l_s_center, u_ls));

% Outer back wheel
v_cg_r = simplify_(wheel_r.v_cg);
[~, omega_r] = omega(Rcr, qr, qpr);

v_contact_r = v_cg_r + cross(omega_r, Rcr*[0; 0; -R]);

w_r = Rcr*[0; 1; 0];
u_r = Rcr*[1; 0; 0];

v_r = dot(v_contact_r, u_r);

u_rs = Rr_s*[1; 0; 0];
w_rs = Rr_s*[0; 1; 0];

v_r_s = -[kappa_r; kappa_r*tan(alpha_r); 0]*phip_r*R;
v_r_s_center = v_r_s + cross(omega_r, Rr_s*[0; 0; R]);

proj_vrs_center = simplify_(dot(v_r_s_center, u_rs));

num_radius_i = numden(radius_i);
num_radius_o = numden(radius_o);
num_radius_r = numden(radius_r);
num_radius_l = numden(radius_l);

inner_outer_wheel = proj_vis_center*num_radius_o - proj_vos_center*num_radius_i;
back_right_wheel = proj_vrs_center*num_radius_l - proj_vls_center*num_radius_r;

sys.descrip.unhol_constraints = {[back_right_wheel; inner_outer_wheel; constraints_i]};
