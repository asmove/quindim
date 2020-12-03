L = sys.descrip.syms(end-2);
w = sys.descrip.syms(end-3);
R = sys.descrip.syms(end-4);

varepsilon = w/L;

syms delta

% Holonomic constraints - Inner and outer angles
sys.descrip.hol_constraints = {tan(delta_i) - tan(delta_o) - varepsilon*tan(delta_i)*tan(delta_o)};

% Unholonomic constraints
% Transformation and rotation matrices
Rc = rot3d(theta, [0; 0; 1]);
Ri = rot3d(theta + delta_i, [0; 0; 1]);
Ro = rot3d(theta + delta_o, [0; 0; 1]);
Rr = rot3d(theta, [0; 0; 1]);
Rl = rot3d(theta, [0; 0; 1]);

radius_1 = w/2 + L/tan(delta_i);
radius_g = radius_1/cos(delta);
radius_l = radius_1 - w/2;
radius_r = radius_1 + w/2;
radius_i = radius_l/cos(delta_i);
radius_o = radius_r/cos(delta_o);

% Wheel aliases
chassi = sys.descrip.bodies{1};
wheel_i = sys.descrip.bodies{2};
wheel_o = sys.descrip.bodies{3};
wheel_r = sys.descrip.bodies{4};
wheel_l = sys.descrip.bodies{5};

% Inner front wheel
omega_c = omega(Rc, sys.kin.q, sys.kin.qp);
[omega_i, ~] = omega(Ri, sys.kin.q, sys.kin.qp);
omega_i(2) = phip_i;
omega_i = Ri*omega_i;    
    
v_cg_i = [xp; yp; 0] + cross(omega_c, Rc*[-w/2; L; 0]);
v_contact_i = v_cg_i + cross(omega_i, Ri*[0; 0; -R]);

u_i = Ri*[1; 0; 0];
w_i = Ri*[0; 1; 0];

v_i = simplify(dot(v_contact_i, u_i));
v_i_perp = simplify(dot(v_contact_i, w_i));

constraints_i = [simplify_(v_i); simplify(v_i_perp)];

% % Outer front wheel
[omega_o, ~] = omega(Ro, sys.kin.q, sys.kin.qp);
omega_o(2) = phip_o;
omega_o = Ro*omega_o;

v_cg_o = [xp; yp; 0] + cross(omega_c, Rc*[w/2; L; 0]);
v_contact_o = v_cg_o + cross(omega_o, Ro*[0; 0; -R]);

u_o = Ro*[1; 0; 0];
w_o = Ro*[0; 1; 0];

v_o = simplify(dot(v_contact_o, u_o));
v_o_perp = simplify(dot(v_contact_o, w_o));

% Inner back wheel
[omega_l, ~] = omega(Rl, sys.kin.q, sys.kin.qp);
omega_l(2) = phip_l;
omega_l = Rl*omega_l;

v_cg_l = [xp; yp; 0] + cross(omega_c, Rc*[w/2; 0; 0]);

v_contact_l = v_cg_l + cross(omega_l, Rl*[0; 0; -R]);

u_l = Rl*[1; 0; 0];
w_l = Rl*[0; 1; 0];

v_l = simplify(dot(v_contact_l, u_l));
v_l_perp = simplify(dot(v_contact_l, w_l));

% Outer back wheel
[omega_r, ~] = omega(Rr, sys.kin.q, sys.kin.qp);
omega_r(2) = phip_r;
omega_r = Rl*omega_r;

v_cg_r = [xp; yp; 0] + cross(omega_c, Rc*[-w/2; 0; 0]);
v_contact_r = v_cg_r + cross(omega_r, Rr*[0; 0; -R]);

w_r = Rr*[0; 1; 0];
u_r = Rr*[1; 0; 0];

v_r = dot(v_contact_r, u_r);

vec_c = [Lc; 0; 0];
v_cg = [xp; yp; 0] + cross(omega_c, Rc*vec_c);

syms delta;

u_g = [cos(delta + theta); sin(delta + theta); 0];
proj_v_cg = dot(v_cg, u_g);

[num_g, den_g] = numden(radius_g);
[num_i, den_i] = numden(radius_i);
[num_o, den_o] = numden(radius_o);
[num_r, den_r] = numden(radius_r);
[num_l, den_l] = numden(radius_l);

A_hol = jacobian(sys.descrip.hol_constraints{1}, sys.kin.q);

v_piv_g_sym_vec = simplify(equationsToMatrix(proj_v_cg, sys.kin.qp));
v_piv_i_sym_vec = simplify(equationsToMatrix(phip_i*R, sys.kin.qp));
v_piv_o_sym_vec = simplify(equationsToMatrix(phip_o*R, sys.kin.qp));
v_piv_r_sym_vec = simplify(equationsToMatrix(phip_r*R, sys.kin.qp));
v_piv_l_sym_vec = simplify(equationsToMatrix(phip_l*R, sys.kin.qp));
v_i_vec = simplify(equationsToMatrix(v_i, sys.kin.qp));
v_i_perp_vec = simplify(equationsToMatrix(v_i_perp, sys.kin.qp));

v_proj_vec = [A_hol; v_piv_g_sym_vec; v_piv_i_sym_vec; v_piv_o_sym_vec; ...
              v_piv_r_sym_vec; v_piv_l_sym_vec; v_i_vec; v_i_perp_vec];

B = [-radius_l, 0, 0, 0, radius_g, 0, 0;
             0, -radius_o, radius_i, 0, 0, 0, 0;
             0, 0, 0, -radius_l, radius_r, 0, 0;
             0, -radius_r, 0, radius_i, 0, 0, 0
             0, 0, 0, 0, 0, 1, 0 ;
             0, 0, 0, 0, 0, 0, 1];

B(1, :) = B(1, :)*tan(delta_i)*cos(delta_i);
B(2, :) = B(2, :)*tan(delta_i)*cos(delta_i);
B(3, :) = B(3, :)*tan(delta_i)*cos(delta_i);
B(4, :) = B(4, :)*tan(delta_i)*cos(delta_i);

B = simplify_(B);

outer_wheel = simplify_((phip_l*R*num_g*den_l - proj_v_cg*num_l*den_g)/tan(delta_i));
inner_outer_wheel = simplify_((phip_i*num_o*den_i - phip_o*num_i*den_o)/tan(delta_i));
left_right_wheel = simplify_((phip_l*num_r*den_l - phip_r*num_l*den_r)/tan(delta_i));
left_inner_wheel = simplify_((phip_i*num_r*den_i - phip_r*num_i*den_r)/tan(delta_i));

sys.descrip.unhol_constraints = {[outer_wheel; inner_outer_wheel; ...
                 left_right_wheel; left_inner_wheel; ...
                 constraints_i]};

A_hol = jacobian(sys.descrip.hol_constraints, sys.kin.q);
A_unhol = equationsToMatrix(sys.descrip.unhol_constraints, sys.kin.qp);

A = [A_hol; A_unhol];
C = simplify_(null(A));


