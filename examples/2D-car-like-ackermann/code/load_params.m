% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% sys.descrip.latex_origs = {{'xpp'}, ...
%                            {'\mathrm{xp}'}, ...
%                            {'x_pos'}, ...
%                            {'ypp'}, ...
%                            {'\mathrm{yp}'}, ...
%                            {'y_pos'}, ...
%                            {'thetapp'}, ...
%                            {'thetap'}, ...
%                            {'\mathrm{theta}'}, ...
%                            {'\mathrm{phipp}'}, ...
%                            {'\mathrm{phip}'}, ...
%                            {'\mathrm{phi}'}, ...
%                            {'\mathrm{p1}'}, ...
%                            {'\mathrm{p2}'}, ...
%                            {'\mathrm{p3}'}};
% 
% sys.descrip.latex_text = {'\ddot{x}', '\dot{x}', 'x', ...
%                           '\ddot{y}', '\dot{y}', 'y', ...                          
%                           '\ddot{\theta}', ...
%                           '\dot{\theta}', ...
%                           '\theta', ...
%                           '\ddot{\phi}', ...
%                           '\dot{\phi}', ...
%                           '\phi', ...
%                           '\, \mathrm{v}', ...
%                           '\omega_{\theta}', ...
%                           '\, \mathrm{\omega_{\phi}}'};

Ic_sym_flatten = reshape(I_c, [1, 9]);
Ii_sym_flatten = reshape(I_i, [1, 9]);
Io_sym_flatten = reshape(I_o, [1, 9]);
Ir_sym_flatten = reshape(I_r, [1, 9]);
Il_sym_flatten = reshape(I_l, [1, 9]);

% Paramater symbolic of the system
Is_sym = [Ic_sym_flatten, Ii_sym_flatten, Io_sym_flatten, Ir_sym_flatten, Il_sym_flatten];
sys.descrip.syms = [mc, mi, mo, mr, ml, Is_sym, R, w, L, g, Lc];

% Penny data
mc_num = 1857;
mi_num = 7;
mo_num = 7;
mr_num = 7;
ml_num = 7;

% [m]
w_num = 1.5;

% [m]
L_num = 4.5;

% [m]
Lc_num = L_num/2;

% 27.106*2.54*1e-2/2 = 0.3442 m
R_num = 27.106*2.54*1e-2/2;

g_num = 9.8;

% Inertia tensor
Ic_num = diag([(mc_num/12)*w_num^2, (mc_num/12)*L_num^2, (mc_num/12)*(w_num^2 + L_num^2)]);
Ii_num = diag([(mi_num/4)*R_num^2, (mi_num/4)*R_num^2, (mi_num/2)*R_num^2]);
Io_num = diag([(mo_num/4)*R_num^2, (mo_num/4)*R_num^2, (mo_num/2)*R_num^2]);
Ir_num = diag([(mr_num/4)*R_num^2, (mr_num/4)*R_num^2, (mr_num/2)*R_num^2]);
Il_num = diag([(ml_num/4)*R_num^2, (ml_num/4)*R_num^2, (ml_num/2)*R_num^2]);

Ic_num_flatten = reshape(Ic_num, [1, 9]);
Ii_num_flatten = reshape(Ii_num, [1, 9]);
Io_num_flatten = reshape(Io_num, [1, 9]);
Ir_num_flatten = reshape(Ir_num, [1, 9]);
Il_num_flatten = reshape(Il_num, [1, 9]);

ms = [mc_num, mi_num, mo_num, mr_num, ml_num];
Is = [Ic_num_flatten, Ii_num_flatten, Io_num_flatten, Ir_num_flatten, Il_num_flatten];

sys.descrip.model_params = [ms, Is, R_num, w_num, L_num, g_num, Lc_num];