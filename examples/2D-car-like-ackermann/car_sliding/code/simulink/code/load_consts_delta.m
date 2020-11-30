% Slipping symbolic loading
syms kappa_i kappa_o kappa_r kappa_l real;
syms alpha_i alpha_o alpha_r alpha_l real;
syms upsilon eta delta real;

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

h = radius_i*cos(delta_i - alpha_i);
ell_1 = radius_i*sin(delta_i - alpha_l);
ell_2 = L - ell_1;

radius_l = h*sec(alpha_l);
radius_r = (w + h)*sec(alpha_r);
radius_o = (w + h)*sec(delta_o + alpha_o);

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

proj_vg_ui = simplify_(dot(v_cg_i, u_i));
proj_vi_ui = simplify_(dot(v_i, u_i));
proj_vi_wi = simplify_(dot(v_i, w_i));

constraints_i = [simplify_(proj_vi_ui - (-kappa_i*proj_vg_ui)); ...
                 simplify_(proj_vi_wi - (-kappa_i*tan(alpha_i))*proj_vg_ui)];

s_i = [1; tan(alpha_i); 0];
v_s_i = -kappa_i*s_i*proj_vg_ui;

rot_dir_i = cross(omega_i, Ri*[0; 0; R])/(phip_i*R);
v_center_i = simplify_(v_s_i + rot_dir_i*phip_i*R);

Rsi = rot3d(theta + delta_i - alpha_i, [0; 0; 1]);
u_s_i = Rsi*[1; 0; 0];
w_s_i = Rsi*[0; 1; 0];

v_piv_i = simplify_(dot(v_center_i, u_s_i));

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

s_o = [1; tan(alpha_o); 0];
v_s_o = -kappa_o*s_o*proj_vg_uo;

rot_dir_o = cross(omega_o, Ro*[0; 0; R])/(phip_o*R);
v_center_o = v_s_o + rot_dir_o*phip_o*R;

Rso = rot3d(theta + delta_o - alpha_o, [0; 0; 1]);
u_s_o = Rso*[1; 0; 0];
w_s_o = Rso*[0; 1; 0];

v_piv_o = simplify_(dot(v_center_o, u_s_o));

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

s_l = [1; tan(alpha_l); 0];
v_s_l = -kappa_l*s_l*proj_vg_ul;

rot_dir_l = cross(omega_l, Rl*[0; 0; R])/(phip_l*R);
v_center_l = v_s_l + rot_dir_l*phip_l*R;

Rsl = rot3d(theta - alpha_l, [0; 0; 1]);
u_s_l = Rsl*[1; 0; 0];
w_s_l = Rsl*[0; 1; 0];

v_piv_l = simplify_(dot(v_center_l, u_s_l));

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

s_r = [1; tan(alpha_r); 0];
v_s_r = -kappa_r*s_r*proj_vg_ur;

rot_dir_r = cross(omega_r, Rr*[0; 0; R])/(phip_r*R);
v_center_r = v_s_r + rot_dir_r*phip_r*R;

Rsr = rot3d(theta - alpha_r, [0; 0; 1]);
u_s_r = Rsr*[1; 0; 0];
w_s_r = Rsr*[0; 1; 0];

v_piv_r = simplify_(dot(v_center_r, u_s_r));

v_cg = [xp; yp; 0] + cross(omega_c, Rc*[0; Lc; 0]);
u_g = [cos(theta + pi - upsilon - eta - alpha_r); ...
       sin(theta + pi - upsilon - eta - alpha_r); ...
       0];

radius_g = (w + h)/cos(pi - eta - upsilon - alpha_r);
proj_v_cg = simplify_(dot(v_cg, u_g));

tan_iil = sin(delta_i - alpha_i + alpha_l)/cos(delta_i - alpha_i);
cos_iil = cos(alpha_i - delta_i);

% outer_wheel = simplify_((v_piv_l*radius_g - proj_v_cg*radius_l));
% inner_outer_wheel = simplify_(v_piv_i*radius_o - v_piv_o*radius_i);
% left_right_wheel = simplify_(v_piv_l*radius_r - v_piv_r*radius_l);
% left_inner_wheel = simplify_(v_piv_r*radius_i - v_piv_i*radius_r);

proj_rotdir_usi = simplify_(dot(cross(omega_i, Ri*[0; 0; R]), u_s_i));
proj_rotdir_uso = simplify_(dot(cross(omega_o, Ro*[0; 0; R]), u_s_o));
proj_rotdir_usr = simplify_(dot(cross(omega_r, Rr*[0; 0; R]), u_s_r));
proj_rotdir_usl = simplify_(dot(cross(omega_l, Rl*[0; 0; R]), u_s_l));

sigma_i = simplify(dot(v_s_i, u_s_i));
sigma_o = simplify(dot(v_s_o, u_s_o));
sigma_r = simplify(dot(v_s_r, u_s_r));
sigma_l = simplify(dot(v_s_l, u_s_l));

v_piv_i_sym = simplify(sigma_i + proj_rotdir_usi);
v_piv_o_sym = simplify(sigma_o + proj_rotdir_uso);
v_piv_r_sym = simplify(sigma_r + proj_rotdir_usr);
v_piv_l_sym = simplify(sigma_l + proj_rotdir_usl);

radius_g_sym = (w + h)/cos(pi - eta - upsilon - alpha_r);
radius_i_sym = L*cos(alpha_i)/sin(delta_i - alpha_i + alpha_l);
radius_o_sym = (w + h)*sec(delta_o + alpha_o);
radius_r_sym = (w + h)*sec(alpha_r);
radius_l_sym = L*cos(delta_i - alpha_i)/sin(delta_i - alpha_i + alpha_l);

[num_g, den_g] = numden(radius_g_sym);
[num_i, den_i] = numden(radius_i_sym);
[num_o, den_o] = numden(radius_o_sym);
[num_r, den_r] = numden(radius_r_sym);
[num_l, den_l] = numden(radius_l_sym);

proj_vi_ui_vec = simplify(equationsToMatrix(proj_vi_ui, sys.kin.qp));
proj_vi_wi_vec = simplify(equationsToMatrix(proj_vi_wi, sys.kin.qp));
v_piv_g_sym_vec = simplify(equationsToMatrix(proj_v_cg, sys.kin.qp));
v_piv_i_sym_vec = simplify(equationsToMatrix(v_piv_i_sym, sys.kin.qp));
v_piv_o_sym_vec = simplify(equationsToMatrix(v_piv_o_sym, sys.kin.qp));
v_piv_r_sym_vec = simplify(equationsToMatrix(v_piv_r_sym, sys.kin.qp));
v_piv_l_sym_vec = simplify(equationsToMatrix(v_piv_l_sym, sys.kin.qp));

v_proj_vec = [v_piv_g_sym_vec; v_piv_i_sym_vec; ...
              v_piv_o_sym_vec; v_piv_r_sym_vec; ...
              v_piv_l_sym_vec; proj_vi_ui_vec; proj_vi_wi_vec];

B = [-radius_l, 0, 0, 0, radius_g, 0, 0;
      0, -radius_o, radius_i, 0, 0, 0, 0;
      0, 0, 0, -radius_l, radius_r, 0, 0;
      0, -radius_r, 0, radius_i, 0, 0, 0
      0, 0, 0, 0, 0, 1 + kappa_i, 0 ;
      0, 0, 0, 0, 0, kappa_i*tan(alpha_i), 1];

B(1, :) = B(1, :)*tan_iil*cos_iil;
B(2, :) = B(2, :)*tan_iil*cos_iil;
B(3, :) = B(3, :)*tan_iil*cos_iil;
B(4, :) = B(4, :)*tan_iil*cos_iil;

B = simplify_(B);

B_equiv = simplify_(subs(B, [alpha_i, alpha_o, alpha_r, alpha_l, kappa_i, eta], [zeros(1, 5), pi - upsilon]));

outer_wheel_sym = v_piv_l_sym*radius_g_sym - proj_v_cg*radius_l;
inner_outer_wheel_sym = v_piv_i_sym*radius_o_sym - v_piv_o_sym*radius_i_sym;
left_right_wheel_sym = v_piv_l_sym*radius_r_sym - v_piv_r_sym*radius_l_sym;
left_inner_wheel_sym = v_piv_r_sym*radius_i_sym - v_piv_i_sym*radius_r_sym;

sys.descrip.unhol_constraints = {simplify_([outer_wheel_sym; inner_outer_wheel_sym; ...
                                            left_right_wheel_sym; left_inner_wheel_sym; ...
                                            constraints_i])};
