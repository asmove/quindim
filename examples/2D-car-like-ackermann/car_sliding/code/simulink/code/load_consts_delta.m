syms kappa_i kappa_o kappa_r kappa_l real;
syms dkappa_i dkappa_o dkappa_r dkappa_l real;

syms alpha_i alpha_o alpha_r alpha_l real;
syms dalpha_i dalpha_o dalpha_r dalpha_l real;

syms sigma delta delta_L ell real;

L = sys.descrip.syms(end-2);
w = sys.descrip.syms(end-3);

theta = sys.kin.q(3);
delta_i = sys.kin.q(4);
delta_o = sys.kin.q(5);

Rc = rot3d(theta, [0; 0; 1]);
Ri = rot3d(theta + delta_i, [0; 0; 1]);
Ro = rot3d(theta + delta_o, [0; 0; 1]);
Rr = rot3d(theta, [0; 0; 1]);
Rl = rot3d(theta, [0; 0; 1]);

% Holonomic constraints - Inner and outer angles
sys.descrip.hol_constraints = {tan(delta_i) - tan(delta_o) - (w/L)*tan(delta_i)*tan(delta_o)};

% Unholonomic constraints
radius_i = L*(cos(alpha_l)/sin(delta_i - alpha_i + alpha_l));

h = radius_i*cos(delta_i - alpha_l);
ell_1 = radius_i*sin(delta_i - alpha_l);
ell_2 = L - ell_1;

radius_l = h*sec(alpha_l);
radius_r = (w + h)*sec(alpha_r);
radius_o = (w + h)*sec(delta_o + alpha_o);

radius_1 = sqrt(ell^2 + (h + w/2)^2);

% Wheel aliases
chassi = sys.descrip.bodies{1};
wheel_i = sys.descrip.bodies{2};
wheel_o = sys.descrip.bodies{3};
wheel_r = sys.descrip.bodies{4};
wheel_l = sys.descrip.bodies{5};

[omega_c, ~] = omega(Rc, sys.kin.q, sys.kin.qp);

% Inner front wheel
[omega_i, ~] = omega(Ri, sys.kin.q, sys.kin.qp);
omega_i(2) = phip_i;
omega_i = Ri*omega_i;

v_cg_i = [xp; yp; 0] + cross(omega_c, Rc*[-w/2; L; 0]);
v_i = v_cg_i + cross(omega_i, Ri*[0; 0; -R]);

u_i = Ri*[1; 0; 0];
w_i = Ri*[0; 1; 0];

proj_vg_ui = dot(v_cg_i, u_i);
proj_vi_ui = dot(v_i, u_i);
proj_vi_wi = dot(v_i, w_i);

v_s_i = -kappa_i*[1; tan(alpha_i); 0]*proj_vg_ui;
v_center_i = v_s_i + cross(omega_i, Ri*[0; 0; R]);

Rsi = rot3d(theta + delta_i - alpha_i, [0; 0; 1]);
u_s_i = Rsi*[1; 0; 0];
w_s_i = Rsi*[0; 1; 0];

v_piv_i = dot(v_center_i, u_s_i);

constraints_i = [simplify_(proj_vi_ui - (-kappa_i*proj_vg_ui)); ...
                 simplify_(proj_vi_wi - (-kappa_i*tan(alpha_i))*proj_vg_ui)];

% Outer front wheel
[omega_o, ~] = omega(Ro, sys.kin.q, sys.kin.qp);
omega_o(2) = phip_o;
omega_o = Ro*omega_o;

v_cg_o = [xp; yp; 0] + cross(omega_c, Rc*[w/2; L; 0]);
v_o = v_cg_o + cross(omega_o, Ro*[0; 0; -R]);

u_o = Ro*[1; 0; 0];
w_o = Ro*[0; 1; 0];

proj_vg_uo = dot(v_cg_o, u_o);
proj_vo_uo = dot(v_o, u_o);

v_s_o = -kappa_o*[1; tan(alpha_o); 0]*proj_vg_uo;
v_center_o = v_s_o + cross(omega_o, Ro*[0; 0; R]);

Rso = rot3d(theta + delta_o - alpha_o, [0; 0; 1]);
u_s_o = Rso*[1; 0; 0];
w_s_o = Rso*[0; 1; 0];

v_piv_o = dot(v_center_o, u_s_o);

% Inner back wheel
[omega_l, ~] = omega(Rl, sys.kin.q, sys.kin.qp);
omega_l(2) = phip_l;
omega_l = Rl*omega_l;

v_cg_l = [xp; yp; 0] + cross(omega_c, Rc*[w/2; 0; 0]);
v_l = v_cg_l + cross(omega_l, Rl*[0; 0; -R]);

u_l = Rl*[1; 0; 0];
w_l = Rl*[0; 1; 0];

proj_vg_ul = dot(v_cg_l, u_l);
proj_vl_ul = dot(v_l, u_l);

v_s_l = -kappa_l*[1; tan(alpha_l); 0]*proj_vg_ul;
v_center_l = v_s_l + cross(omega_l, Rl*[0; 0; R]);

Rsl = rot3d(theta + alpha_l, [0; 0; 1]);
u_s_l = Rsl*[1; 0; 0];
w_s_l = Rsl*[0; 1; 0];

v_piv_l = dot(v_center_l, u_s_l);

% Outer back wheel
[omega_r, ~] = omega(Rr, sys.kin.q, sys.kin.qp);
omega_r(2) = phip_r;
omega_r = Rl*omega_r;

v_cg_r = [xp; yp; 0] + cross(omega_c, Rc*[-w/2; 0; 0]);
v_r = v_cg_r + cross(omega_r, Rr*[0; 0; -R]);

v_contact_r = [xp; yp; 0] + cross(omega_r, Rr*[0; 0; -R]);
v_r = v_cg_r + cross(omega_r, Ro*[0; 0; -R]);

u_r = Rr*[1; 0; 0];
w_r = Rr*[0; 1; 0];

proj_vg_ur = dot(v_cg_r, u_r);
proj_vr_ur = dot(v_r, u_r);

v_s_r = -kappa_r*[1; tan(alpha_r); 0]*proj_vg_ur;
v_center_r = v_s_r + cross(omega_r, Rr*[0; 0; R]);

Rsr = rot3d(theta + alpha_r, [0; 0; 1]);
u_s_r = Rsr*[1; 0; 0];
w_s_r = Rsr*[0; 1; 0];

v_piv_r = dot(v_center_r, u_s_r);

v_cg = [xp; yp; 0] + cross(omega_c, Rc*[0; Lc; 0]);
u_delta = [cos(theta + sigma); sin(theta + sigma); 0];

sigma_subs = acos(radius_1/(h+w/2));

proj_v_cg = dot(v_cg, u_delta);

sin_iil = sin(delta_i - alpha_i + alpha_l);
tan_iil = sin(-delta_i + alpha_i + alpha_l)/(cos(alpha_r)*cos(delta_i - alpha_i));

[num_g, den_g] = numden(radius_g);
[num_i, den_i] = numden(radius_i);
[num_o, den_o] = numden(radius_o);
[num_r, den_r] = numden(radius_r);
[num_l, den_l] = numden(radius_l);

outer_wheel = simplify_(v_piv_l*radius_g - proj_v_cg*radius_l);
inner_outer_wheel = simplify_(v_piv_r*radius_o - v_piv_o*radius_r);
left_right_wheel = simplify_(v_piv_l*radius_r - v_piv_r*radius_l);
left_inner_wheel = simplify_(v_piv_r*radius_o - v_piv_o*radius_r);

[~, den_ow] = numden(outer_wheel);
[num_iow, den_iow] = numden(inner_outer_wheel);
[~, den_lrw] = numden(left_right_wheel);
[~, den_liw] = numden(left_inner_wheel);

outer_wheel = outer_wheel*den_ow/R;
inner_outer_wheel = inner_outer_wheel*den_iow*R/(32*num_o);
left_right_wheel = left_right_wheel*den_lrw/(R*cos(alpha_l - delta_i));
left_inner_wheel = left_inner_wheel*den_liw/(32*R);

sys.descrip.unhol_constraints = {[outer_wheel; inner_outer_wheel; ...
                                  left_right_wheel; left_inner_wheel; constraints_i]};

