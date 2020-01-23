% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/rolling_disk/code/main.m');
f = sys.dyn.f;
G = sys.dyn.G;

y = sys.kin.q(1:2);
y_ref = sys.kin.q(1:2);
states = sys.dyn.states;

q = sys.kin.q;
p = sys.kin.p{end};
C = sys.kin.C;
Cp = sys.kin.Cp;

H = sys.dyn.H;
h = sys.dyn.h;
Z = sys.dyn.Z;
u = sys.descrip.u;

v = sym('v', size(u));
u_ = inv(Z)*(H*v + h);

y = sys.kin.q(1:2);

% Output equations
y1 = y(1);
y2 = y(2);

% First derivative for outputs
dy1dt = dvecdt(y1, q, C*p);
dy2dt = dvecdt(y2, q, C*p);

L_G_L_f_h1 = equationsToMatrix(dy1dt, v);
L_G_L_f_h2 = equationsToMatrix(dy2dt, v);

L_f_h1 = simplify_(dy1dt - L_G_L_f_h1*v);
L_f_h2 = simplify_(dy2dt - L_G_L_f_h2*v);

% Second derivative for outputs
d2y1dt2 = dvecdt(dy1dt, [q; p], [C*p; v]);
d2y2dt2 = dvecdt(dy2dt, [q; p], [C*p; v]);

L_G_L_f_2_h1 = equationsToMatrix(d2y1dt2, v);
L_G_L_f_2_h2 = equationsToMatrix(d2y2dt2, v);

L_f_h1 = simplify_(d2y1dt2 - L_G_L_f_h1*v);
L_f_h2 = simplify_(d2y2dt2 - L_G_L_f_h2*v);

A = [L_G_L_f_2_h1; L_G_L_f_2_h2];

x_orig = [q; p; v(2)];
x_sym = sym('x_', [7, 1]);

y1 = subs(y1, x_orig, x_sym);
dy1dt = subs(dy1dt, x_orig, x_sym);
d2y1dt2 = subs(d2y1dt2, x_orig, x_sym);

y2 = subs(y1, x_orig, x_sym);
dy2dt = subs(dy1dt, x_orig, x_sym);
d2y2dt2 = subs(d2y1dt2, x_orig, x_sym);

z_transf = [y1; dy1dt; d2y1dt2; y2; dy2dt; d2y2dt2; x_sym(4)];
z_sym = sym('z_', [7, 1]);

R = sys.descrip.syms(2);
symbs = sys.descrip.syms;
model_params = sys.descrip.model_params;

w = sym('w', [2, 1]);
B = [0, 1; 1, 0];

plant = [C*p; inv(H)*(-h + Z*B*[x_sym(7); w(2)]); w(1)];
plant = subs(plant, x_orig, x_sym);
plant = subs(plant, symbs, model_params);

x_to_z = [x_sym(1); ...
          R*x_sym(6)*cos(x_sym(3)); ...
          R*(x_sym(7)*cos(x_sym(3)) - x_sym(5)*x_sym(6)*sin(x_sym(3))); ...
          x_sym(2); ...
          R*x_sym(6)*sin(x_sym(3)); ...
          R*(x_sym(7)*sin(x_sym(3)) + x_sym(5)*x_sym(6)*cos(x_sym(3))); ...
          x_sym(4)];

z_to_x = [z_sym(1); ...
          z_sym(4); ...
          atan(z_sym(5)/z_sym(2)); ...
          z_sym(7); ...
          (z_sym(6)*z_sym(2) - z_sym(3)*z_sym(5))/(z_sym(2)^2 + z_sym(5)^2); ...
          sqrt(z_sym(2)^2 + z_sym(5)^2)/R; ...
          (z_sym(3)*z_sym(2) + ...
           z_sym(6)*z_sym(5))/(R*sqrt(z_sym(2)^2 + z_sym(5)^2))];

% x_params = ones(length(x_sym), 1);
% model_params = sys.descrip.model_params;
% 
% z1 = double(subs(x_to_z, [x_sym; symbs.'], [x_params; model_params.']));
% x1 = double(subs(z_to_x, [z_sym; symbs.'], [z1; model_params.']));
% 
% jac_xz = jacobian(x_to_z, x_sym);
% det_xz = det(jac_xz);
% 
% % New input
% w_1 = sym('w_1');
% w_2 = sym('w_2');
% z_1 = sym('z_1');
% 
% u_new = [z_1; w_2];
% qpz = [q; p; z_1];
% 
% % Plant
% plant = subs([C*p; u_new; w_1], qpz, x_sym);
% zp = simplify_(dvecdt(x_to_z, x_sym, plant));
% zp = simplify_(subs(zp, x_sym, z_to_x));
% 
% G_x = equationsToMatrix(plant, [w_1; w_2]);
% f_x = simplify_(plant - G_x*[w_1; w_2]);
% 
% d2y1dt2 = subs(d2y1dt2, u(1), z_1);
% d2y2dt2 = subs(d2y2dt2, u(1), z_1);
% 
% % Old input
% w_s = [z_1; w_2];
% 
% % Third derivative for outputs
% d3y1dt3 = dvecdt(d2y1dt2, [q; p; z_1], [C*p; w_s; w_1]);
% d3y2dt3 = dvecdt(d2y2dt2, [q; p; z_1], [C*p; w_s; w_1]);


% ------------------------------------------------------------


% 
% u_new = [w_1; w_2];
% 
% % 3rd - Lie derivative for f
% L_G_L_f_3_h1 = simplify_(equationsToMatrix(d3y1dt3, u_new));
% L_G_L_f_3_h2 = simplify_(equationsToMatrix(d3y2dt3, u_new));
% 
% % 3rd - Lie derivative for h
% L_f_2_h1 = simplify_(d3y1dt3 - L_G_L_f_3_h1*u_new);
% L_f_2_h2 = simplify_(d3y2dt3 - L_G_L_f_3_h2*u_new);
% 
% zs = [y1; dy1dt; d2y1dt2; y2; dy2dt; d2y2dt2];
% 
% % Decoupling matrix
% Delta = ;
% 
% syms k11 k12 k13 k21 k22 k23;
% syms xppp_ref xpp_ref xp_ref x_ref
% syms yppp_ref ypp_ref yp_ref y_ref
% 
% poles1 = [-1, -2, -3];
% poles2 = [-1, -2, -3];
% 
% coeffs1 = poly(poles1);
% coeffs2 = poly(poles2);
% 
% coeffs1 = coeffs1(2:end);
% coeffs2 = coeffs2(2:end);
% 
% % X and Y derivatives
% x = y1;
% y = y2;
% 
% xp = dy1dt;
% yp = dy2dt;
% 
% xpp = d2y1dt2;
% ypp = d2y2dt2;
% 
% % X and Y error derivatives
% epp_x = d2y1dt2 - xpp_ref;
% ep_x = dy1dt - xp_ref;
% e_x = y - x_ref;
% 
% epp_y = d2y2dt2 - ypp_ref;
% ep_y = dy2dt - yp_ref;
% e_y = y2 - y_ref;
% 
% % Gains concatenation
% K3 = diag([k13, k23]);
% K2 = diag([k12, k22]);
% K1 = diag([k11, k21]);
% 
% % Errors and its derivatives
% e = [e_x; e_y];
% ep = [ep_x; ep_y];
% epp = [epp_x; epp_y];
% 
% w = inv(Delta)*;
% 
% plant = subs(plant, symbs, params);
% 
% % Control
% symbs = sys.descrip.syms;
% params = sys.descrip.model_params;
% 
% ks = [k11; k12; k13; k21; k22; k23];
% w = subs(w, symbs, params);
% w = subs(w, ks, [coeffs1'; coeffs2']);
% 
% q = sys.kin.q;
% p = sys.kin.p{end};
% 
% % Ellipsoid trajectory
% a = 1;
% b = 2;
% omega = 1;
% 
% ref_func = @(t) [a*cos(omega*t); b*sin(omega*t); ...
%                  -a*omega*sin(omega*t); b*omega*cos(omega*t); ...
%                  -a*omega^2*cos(omega*t); -b*omega^2*sin(omega*t); ...
%                  a*omega^3*sin(omega*t); -b*omega^3*cos(omega*t)];
% 
% qp_qp_ref_s = [q; p; z_1; ...
%                x_ref; y_ref; ...
%                xp_ref; yp_ref; ...
%                xpp_ref; ypp_ref; ...
%                xppp_ref; yppp_ref];
% 
% w = simplify_(w);
% u_func = @(t, q_p) subs(w, qp_qp_ref_s, [q_p; ref_func(t)]);
% 
% x0 = [0; 0; 0; 0; 0; 1; 0];
% tf = 5;
% dt = 0.1;
% 
% qp_syms = [q; p; z_1];
% 
% sol = sim_model(plant, x0, u_func, u_new, qp_syms, tf, dt);
% 
