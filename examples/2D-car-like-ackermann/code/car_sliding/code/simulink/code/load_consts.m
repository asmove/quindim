% Holonomic constraints - Inner and outer angles
sys.descrip.hol_constraints = {tan(delta_i) - tan(delta_o) - (w/L)*tan(delta_i)*tan(delta_o)};

% Unholonomic constraints
cot_delta = (1/tan(delta_o) + 1/tan(delta_i))/2;
delta = acot(cot_delta);

R_1 = L*cot_delta;
R_ = sqrt(R_1^2 + Lc^2);

varepsilon = w/L;
vareps_tan = varepsilon*tan(delta_i)/(1 + (varepsilon/2)*tan(delta_i));
inner_outer_wheel = sec(delta_i)*phip_i - sec(delta_o)*(1 - vareps_tan)*phip_o;

% Transformation and rotation matrices
Rc = simplify(Tc(1:3, 1:3));

Tci = Tc*Ti1;
Rci = simplify_(Tci(1:3, 1:3));

Tco = Tc*To1;
Rco = simplify_(Tco(1:3, 1:3));

Tcr = Tc*Tr1;
Rcr = simplify_(Tcr(1:3, 1:3));

Tcl = Tc*Tl1;
Rcl = simplify_(Tcl(1:3, 1:3));

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

R = sys.descrip.syms(end-4);

v_i = simplify(dot(v_contact_i, u_i));
v_i_perp = simplify(dot(v_contact_i, w_i));
constraints_i = [simplify_(v_i - phip_i*R); simplify(v_i_perp)];

% % Outer front wheel
[~, omega_o] = omega(Rco, qo, qpo);
v_cg_o = [xp; yp; 0] + cross(omega_c, Rc*[-w/2; L; 0]);

v_contact_o = v_cg_o + cross(omega_o, Rco*[0; 0; -R]);
u_o = Rco*[1; 0; 0];
w_o = Rco*[0; 1; 0];

v_o = simplify(dot(v_contact_o, u_o));
v_o_perp = simplify(dot(v_contact_o, w_o));

% Inner back wheel
[~, omega_l] = omega(Rcl, ql, qpl);
v_cg_l = [xp; yp; 0] + cross(omega_c, Rc*[w/2; 0; 0]);
v_contact_l = v_cg_l + cross(omega_l, Rcl*[0; 0; -R]);

u_l = Rcl*[1; 0; 0];
w_l = Rcl*[0; 1; 0];

v_l = simplify(dot(v_contact_l, u_l));
v_l_perp = simplify(dot(v_contact_l, w_l));

% Outer back wheel
[~, omega_r] = omega(Rcr, qr, qpr);

v_contact_r = [xp; yp; 0] + cross(omega_r, Rcr*[0; 0; -R]);

w_r = Rcr*[0; 1; 0];
u_r = Rcr*[1; 0; 0];

v_r = dot(v_contact_r, u_r);

back_right_wheel = phip_l - phip_r*(1 + (w/L)*tan(delta_i));
sys.descrip.unhol_constraints = {[back_right_wheel; inner_outer_wheel; constraints_i]};
