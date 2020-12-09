T_c = sys.descrip.bodies{1}.T;
T_r = sys.descrip.bodies{2}.T;
T_l = sys.descrip.bodies{3}.T;
T_f = sys.descrip.bodies{4}.T;
T_s = sys.descrip.bodies{5}.T;

R0c = T_c(1:3, 1:3);
R0f = T_f(1:3, 1:3);
R0r = T_r(1:3, 1:3);
R0l = T_l(1:3, 1:3);
R0s = T_s(1:3, 1:3);

omega_c = omega(R0c, sys.kin.q, sys.kin.qp);
omega_f = omega(R0f, sys.kin.q, sys.kin.qp);
omega_r = omega(R0r, sys.kin.q, sys.kin.qp) + R0r*[0; phip_r; 0];
omega_l = omega(R0l, sys.kin.q, sys.kin.qp) + R0l*[0; phip_l; 0];
omega_s = omega(R0s, sys.kin.q, sys.kin.qp) + R0s*[0; phip_s; 0];

v_gr = [xp; yp; 0] + cross(omega_c, [0; w/2; 0]);
v_gl = [xp; yp; 0] + cross(omega_c, [0; -w/2; 0]);
v_f = [xp; yp; 0] + cross(omega_c, [L_f; 0; 0]);
v_s = v_f + cross(omega_f, [0; 0; -L_s]);

v_r = v_gr + cross(omega_r, [0; 0; -R]);
v_l = v_gl + cross(omega_l, [0; 0; -R]);
v_c = v_s + cross(omega_s, [0; 0; -R_s]);

u_s = R0s*[1; 0; 0];
w_s = R0s*[0; 1; 0];

ell2 = (L_c*sin(beta_))^2 + (L_f*cos(beta_))^2;
radius_1 = L_f*cos(beta_)/sin(beta_);
radius_s = radius_1/cos(beta_);
radius_g = sqrt(ell2)/sin(beta_);
radius_r = radius_1 + w/2;
radius_l = radius_1 - w/2;

num_radius_1 = L_f*cos(beta_);
num_radius_s = L_f;
num_radius_g = sqrt(ell2);
num_radius_r = L_f*cos(beta_) + w*sin(beta_)/2;
num_radius_l = L_f*cos(beta_) - w*sin(beta_)/2;

T = sys.descrip.bodies{1}.T;
p_cg = sys.descrip.bodies{1}.p_cg;
p_g = T*[p_cg; 1];
p_g = p_g(1:3);

q = sys.kin.q;
qp = sys.kin.qp;
v_cg = dvecdt(p_g, q, qp);
v_cg = v_cg(1:3);

syms beta_g ell scaler_g;

orient_g = [cos(th + beta_g); sin(th + beta_g); 0];

v_g = simplify(dot(v_cg, orient_g));

g_constraint = phip_s*R_s - scaler_g*v_g;
angvel_constraints = [g_constraint; ...
                      phip_l*num_radius_r - phip_r*num_radius_l; ...
                      phip_s*R_s*num_radius_r - phip_r*R*num_radius_s];

sys.descrip.unhol_constraints = [simplify_(dot(v_c, u_s)); ...
                                 simplify_(dot(v_c, w_s)); ...
                                 angvel_constraints];

% Kinematic and dynamic model
sys = kinematic_model(sys);


