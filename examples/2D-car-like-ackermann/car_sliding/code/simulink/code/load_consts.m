syms kappa_i kappa_o kappa_r kappa_l real;
syms dkappa_i dkappa_o dkappa_r dkappa_l real;

syms alpha_i alpha_o alpha_r alpha_l real;
syms dalpha_i dalpha_o dalpha_r dalpha_l real;

theta = sys.kin.q(3);
delta_i = sys.kin.q(4);
delta_o = sys.kin.q(5);

% Holonomic constraints - Inner and outer angles
sys.descrip.hol_constraints = {tan(delta_i) - tan(delta_o) - (w/L)*tan(delta_i)*tan(delta_o)};

L = sys.descrip.syms(end-2);
w = sys.descrip.syms(end-3);

% Unholonomic constraints
cot_delta = (1/tan(delta_o) + 1/tan(delta_i))/2;
delta = acot(cot_delta);

radius_1 = L*cot_delta;
R_ = sqrt(R_1^2 + Lc^2);

radius_i = (cos(alpha_l)/sin(delta_i - alpha_i + alpha_l))*L;

h = radius_i*cos(delta_i - alpha_l);
ell_1 = R_i*sin(delta_i - alpha_l);
ell_2 = L - ell_1;

radius_l = (cos(delta_i - alpha_i)/sin(delta_i - alpha_i + alpha_l))*L;
radius_r = ell_1*csc(alpha_r);
radius_o = ell_2*sec(delta_o + alpha_l);

Rc = rot3d(theta, [0; 0; 1]);
Ri = rot3d(theta + delta_i, [0; 0; 1]);
Ro = rot3d(theta + delta_o, [0; 0; 1]);
Rr = rot3d(theta, [0; 0; 1]);
Rl = rot3d(theta, [0; 0; 1]);

omega_c = [0; 0; thetap];

% Wheel aliases
chassi = sys.descrip.bodies{1};
wheel_i = sys.descrip.bodies{2};
wheel_o = sys.descrip.bodies{3};
wheel_r = sys.descrip.bodies{4};
wheel_l = sys.descrip.bodies{5};

% Inner front wheel
omega_i = [-phip_i*sin(theta); phip_i*cos(theta); thetap + deltap_i];

v_cg_i = [xp; yp; 0] + cross(omega_c, Ri*[-w/2; L; 0]);
v_i = v_cg_i + cross(omega_i, Ri*[0; 0; -R]);

u_i = Ri*[1; 0; 0];
w_i = Ri*[0; 1; 0];

proj_vi_ui = dot(v_i, u_i);
v_s_i = -[kappa_i; kappa_i*tan(alpha_i); 0]*proj_vi_ui;
v_center_i = v_s_i + cross(omega_i, Ri*[0; 0; R]);

v_proj_ui = dot(v_i, u_i);
v_proj_wi = dot(v_i, w_i);

v_i = simplify(dot(v_contact_i, u_i));
v_i_perp = simplify(dot(v_contact_i, w_i));
constraints_i = [simplify_(v_i); simplify(v_i_perp)];

Rsi = rot3d(theta + delta_i - alpha_i, [0; 0; 1]);
u_s_i = Rsi*[1; 0; 0];
w_s_i = Rsi*[0; 1; 0];

v_piv_i = dot(v_center_i, u_s_i);

% Outer front wheel
omega_o = [-phip_o*sin(theta); phip_o*cos(theta); thetap + deltap_o];
v_cg_o = [xp; yp; 0] + cross(omega_c, Rc*[w/2; L; 0]);
v_o = v_cg_o + cross(omega_o, Ro*[0; 0; -R]);

u_o = Ro*[1; 0; 0];
w_o = Ro*[0; 1; 0];

proj_vo_uo = dot(v_o, u_o);
v_s_o = -[kappa_o; kappa_o*tan(alpha_o); 0]*proj_vo_uo;
v_center_o = v_s_o + cross(omega_o, Ro*[0; 0; R]);

Rso = rot3d(theta + delta_o - alpha_o, [0; 0; 1]);
u_s_o = Rso*[1; 0; 0];
w_s_o = Rso*[0; 1; 0];

v_piv_o = dot(v_center_o, u_s_o);

% Inner back wheel
omega_l = [-phip_l*sin(theta); phip_l*cos(theta); thetap];
v_cg_l = [xp; yp; 0] + cross(omega_c, Rc*[w/2; 0; 0]);
v_l = v_cg_l + cross(omega_l, Rl*[0; 0; -R]);

u_l = Rl*[1; 0; 0];
w_l = Rl*[0; 1; 0];

proj_vl_ul = dot(v_l, u_l);
v_s_l = -[kappa_l; kappa_l*tan(alpha_l); 0]*proj_vl_ul;
v_center_l = v_s_l + cross(omega_l, Rl*[0; 0; R]);

Rsl = rot3d(theta + alpha_l, [0; 0; 1]);
u_s_l = Rsl*[1; 0; 0];
w_s_l = Rsl*[0; 1; 0];

v_piv_l = dot(v_center_o, u_s_o);

% Outer back wheel
omega_r = [-phip_r*sin(theta); phip_r*cos(theta); thetap];
v_cg_r = [xp; yp; 0] + cross(omega_c, Rc*[-w/2; 0; 0]);
v_r = v_cg_r + cross(omega_r, Rr*[0; 0; -R]);

v_contact_r = [xp; yp; 0] + cross(omega_r, Rr*[0; 0; -R]);
v_r = v_cg_r + cross(omega_r, Ro*[0; 0; -R]);

u_r = Rr*[1; 0; 0];
w_r = Rr*[0; 1; 0];

proj_vr_ur = dot(v_r, u_r);
v_s_r = -[kappa_r; kappa_r*tan(alpha_r); 0]*proj_vr_ur;
v_center_r = v_s_r + cross(omega_r, Rr*[0; 0; R]);

Rsr = rot3d(theta + alpha_r, [0; 0; 1]);
u_s_r = Rsr*[1; 0; 0];
w_s_r = Rsr*[0; 1; 0];

v_piv_r = dot(v_center_o, u_s_o);

back_right_wheel = v_piv_i*radius_o - v_piv_o*radius_i;
inner_outer_wheel = v_piv_l*radius_r - v_piv_r*radius_l;

sys.descrip.unhol_constraints = {[back_right_wheel; inner_outer_wheel; constraints_i]};

