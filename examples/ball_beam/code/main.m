% % Author: Bruno Peixoto
% % Date: 30/10/19
% 
% clear all
% close all
% clc
% 
% syms g f_phi;
% 
% % Body 1
% syms m_b m_w R Lg g real;
% syms phi th r real;
% syms phip thp rp real;
% syms phipp thpp rpp real;
% 
% I_b = sym('I_b_', [3, 1]);
% I_b = diag(I_b);
% 
% I_w = sym('I_w_', [3, 1]);
% I_w = diag(I_w);
% 
% % Rotations to body
% T1 = T3d(phi, [0; 0; 1], [0; 0; 0]);
% T2 = T3d(th, [0; 0; 1], [r; R; 0]);
% T_b = {T1};
% T_w = {T1, T2};
% 
% % CG position of the bar to body coordinate system
% L = [Lg; 0; 0];
% 
% % Generalized coordinates
% sys.kin.q = [phi; th; r];
% sys.kin.qp = [phip; thp; rp];
% sys.kin.qpp = [phipp; thpp; rpp];
% 
% % Previous body
% previous = struct('');
% 
% bar = build_body(m_b, I_b, T_b, L, {}, {}, ...
%                  phi, phip, phipp, previous, []);
%                
% wheel = build_body(m_w, I_w, T_w, zeros(3, 1), {}, {}, ...
%                    th, thp, thpp, bar, []);
%                
% sys.descrip.bodies = {bar, wheel};
% 
% % Gravity utilities
% sys.descrip.gravity = [0; -g; 0];
% sys.descrip.g = g;
% 
% % Paramater symbolics of the system
% sys.descrip.syms = [m_b, m_w, R, Lg, diag(I_b).', diag(I_w).', g];
% 
% % Penny data
% sys.descrip.model_params = ones(1, length(sys.descrip.syms));
% 
% % External excitations
% sys.descrip.Fq = [f_phi; 0; 0];
% sys.descrip.u = f_phi;
% 
% % Constraint condition
% sys.descrip.is_constrained = true;
% 
% % State space representation
% sys.descrip.states = [phi; th];
% 
% % Constraint condition
% sys.descrip.is_constrained = false;
% 
% % Kinematic and dynamic model
% sys = kinematic_model(sys);
% 
% sys.descrip.is_constrained = true;
% 
% % Velocity from wheel equal to bar
% T_b = sys.descrip.bodies{1}.T;
% T_bw = sys.descrip.bodies{2}.T;
% R_b = T_b(1:3, 1:3);
% R_bw = T_bw(1:3, 1:3);
% 
% v_bar_contact = r*dvecdt(T_b(1:3, 1), sys.kin.q, sys.kin.qp);
% 
% p_w = point(T_b, [r; R; 0]);
% v_wheel_center = dvecdt(p_w, sys.kin.q, sys.kin.qp);
% omega_w = omega(R_bw, sys.kin.q, sys.kin.qp);
% v_wheel_contact = v_wheel_center + cross(omega_w, R_b*[0; -R; 0]);
% 
% constraints = v_wheel_contact - v_bar_contact;
% sys.descrip.unhol_constraints = {simplify_(constraints(1:2))};
% 
% % Kinematic and dynamic model
% sys = kinematic_model(sys);
% sys = dynamic_model(sys);
% 
% % Time [s]
% dt = 0.1;
% tf = 10;
% t = 0:dt:tf; 
% 
% % Initial conditions [m; m/s]
% x0 = [0; 0; 1; 0; 0];
% 
% % System modelling
% sol = validate_model(sys, t, x0, 0);
% 
% x = t';
% y = sol';
% 
% % Generalized coordinates
% plot_info_q.titles = {'', '', ''};
% plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]'};
% plot_info_q.ylabels = {'$\phi$', '$\theta$', '$r$'};
% plot_info_q.grid_size = [3, 1];
% 
% hfigs_states = my_plot(x, y(:, 1:3), plot_info_q);
% 
% plot_info_p.titles = {'', ''};
% plot_info_p.xlabels = {'$t$ [s]', '$t$ [s]'};
% plot_info_p.ylabels = {'$\omega_{\phi}$', '$\dot r$'};
% plot_info_p.grid_size = [2, 1];
% 
% % States plot
% hfigs_speeds = my_plot(x, y(:, 4:5), plot_info_p);

% Energies plot
hfig_consts = plot_constraints(sys, x, y);
% hfig_energies = plot_energies(sys, x, y);
% 
% % Images
% for i = 1:length(hfig_energies)
%     saveas(hfig_energies, ['../images/energies_', num2str(i)], 'epsc');
% end
% 
% for i = 1:length(hfig_speeds) 
%     saveas(hfigs_states, ['../images/speeds_', num2str(i)], 'epsc'); 
% end
% 
% for i = 1:length(hfig_states) 
%     saveas(hfigs_states, ['../images/states_', num2str(i)], 'epsc'); 
% end
%     
% for i = 1:length(hfig_consts) 
%     saveas(hfig_consts, ['../images/consts_', num2str(i)], 'epsc'); 
% end