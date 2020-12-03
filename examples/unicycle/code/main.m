% Author: Bruno Peixoto
% Date: 08/01/19

if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

syms tau_1 tau_2;

% Body 1
syms m1 m2 mc R1 R2 Lc_x Lc_y Lc_z L2_x L2_y L2_z g real;
syms x y th psi phi1 phi2 real;
syms xp yp thp psip phi1p phi2p real;
syms xpp ypp thpp psipp phi1pp phi2pp real;

I1 = sym('I1_', [3, 1], 'real');
I1 = diag(I1);

Ic = sym('Ic_', [3, 1], 'real');
Ic = diag(Ic);

I2 = sym('I2_', [3, 1], 'real');
I2 = diag(I2);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x; y; 0]);
T2 = T3d(th, [0; 0; 1], [0; 0; 0]);
T3 = T3d(psi, [1; 0; 0], [0; 0; 0]);
T4 = T3d(0, [0; 1; 0], [0; 0; R1]);
T5 = T3d(phi1, [0; 1; 0], [0; 0; 0]);
T6 = T3d(phi2, [1; 0; 0], [L2_x; L2_y; L2_z]);

T1s = {T1, T2, T3, T4};
Tcs = {T1, T2, T3, T4};
T2s = {T1, T2, T3, T4};

% CG position relative to body coordinate system
L1 = [0; 0; 0];
Lc = [Lc_x; Lc_y; Lc_z];
L2 = [0; 0; 0];

% Generalized coordinates
sys.kin.q = [x; y; th; psi; phi1; phi2];
sys.kin.qp = [xp; yp; thp; psip; phi1p; phi2p];
sys.kin.qpp = [xpp; ypp; thpp; psipp; phi1pp; phi2pp];

% Previous body
previous = struct('');

wheel = build_body(m1, I1, T1s, L1, {}, {}, ...
                   [x, y, th, psi, phi1].', ...
                   [xp, yp, thp, psip, phi1p].', ...
                   [xpp, ypp, thpp, psipp, phi1pp].', ...
                   previous, []);

% Rolling velocity is hard to account on angular speed
wheel = update_omega(wheel, wheel.R, [0; phi1p; 0]);

chassi = build_body(mc, Ic, Tcs, Lc, {}, {}, ...
                    [x, y, th, psi, phi1].', ...
                    [xp, yp, thp, psip, phi1p].', ...
                    [xpp, ypp, thpp, psipp, phi1pp].', ...
                    wheel, []);

reaction_wheel = build_body(m2, I2, T2s, L2, {}, {}, ...
                            [x, y, th, psi, phi1, phi2].', ...
                            [xp, yp, thp, psip, phi1p, phi2p].', ...
                            [xpp, ypp, thpp, psipp, phi1pp, phi2pp].', ...
                            chassi, []);

reaction_wheel = update_omega(reaction_wheel, reaction_wheel.R, [0; phi2p; 0]);

sys.descrip.bodies = {wheel, chassi, reaction_wheel};

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Paramater symbolics of the system
sys.descrip.syms = [m1 mc m2 diag(I1)' diag(Ic)' diag(I2)' ...
                    R1 R2 Lc_x Lc_y Lc_z L2_x L2_y L2_z g];

% Penny data
sys.descrip.model_params = [1 1 1 ...
                            0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, ...
                            0.2, 0.5 0 0 1 0 0 0.5 2];

% External excitations
sys.descrip.Fq = [0; 0; 0; 0; tau_1; tau_2];
sys.descrip.u = [tau_1; tau_2];

% State space representation
sys.descrip.states = [x; y; th; psi; phi1; phi2];

% Constraint condition
sys.descrip.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);

% Constraint condition
sys.descrip.is_constrained = true;

T1s = T1*T2*T3*T4;
R1s = T1s(1:3, 1:3);

v_cg = simplify_(sys.descrip.bodies{1}.v_cg);

constraints = v_cg + cross(wheel.omega, R1s*[0; 0; -R1]);

x1 = R1s(:, 1);
y1 = R1s(:, 2);

% Nonholonomic constraints
sys.descrip.unhol_constraints = {simplify_(dot(v_cg, x1)),
                                 simplify_(dot(v_cg, y1))};

% Kinematic and dynamic model
sys = kinematic_model(sys);

[~, cos_psi] = numden(sys.kin.C(1, 2));
sys.kin.C(:, 2) = sys.kin.C(:, 2)*cos_psi;
sys.kin.Cs{1} = sys.kin.C;

sys = dynamic_model(sys);

% Time [s]
dt = 0.01;
tf = 5;
t = 0:dt:tf; 

% Initial conditions [m; m/s]
x0 = [1, 1, pi/4, 0, 0, 0, 0.5, 1, 0.5, 1]';

% System modelling
u_func = @(t, x) zeros(length(sys.descrip.u), 1);

% Model loading
model_name = 'simple_model';

gen_scripts(sys, model_name);

load_system(model_name);

simMode = get_param(model_name, 'SimulationMode');
set_param(model_name, 'SimulationMode', 'normal');

cs = getActiveConfigSet(model_name);
mdl_cs = cs.copy;
set_param(mdl_cs, 'SolverType','Variable-step', ...
                  'AbsTol', '1e-5', 'RelTol', '1e-5', ...
                  'SaveState','on','StateSaveName','xoutNew', ...
                  'SaveOutput','on','OutputSaveName','youtNew');

save_system();
              
t0 = tic();
simOut = sim(model_name, mdl_cs);
toc(t0);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
x = [q, p];

states = simOut.states.signals.values;
q_speeds = simOut.q_speeds.signals.values;
tspan = simOut.tout;

% Generalized coordinates
plot_info_q.titles = repeat_str('', 3);
plot_info_q.xlabels = repeat_str('$t$ [s]', 3);
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$'};
plot_info_q.grid_size = [3, 1];

hfigs_states = my_plot(tspan, x(:, 1:3), plot_info_q);

% Generalized coordinates
plot_info_q.titles = repeat_str('', 2);
plot_info_q.xlabels = repeat_str('$t$ [s]', 2);
plot_info_q.ylabels = {'$\phi_1$', '$\phi_2$'};
plot_info_q.grid_size = [2, 1];

hfigs_states = my_plot(tspan, x(:, 4:5), plot_info_q);

plot_info_p.titles = repeat_str('', length(sys.kin.p{end}));
plot_info_p.xlabels = repeat_str('$t [s]$', length(sys.kin.p{end}));
plot_info_p.ylabels = {'$\omega_{\theta}$', '$p_2$', ...
                      '$\omega_{\phi_1}$', '$\omega_{\phi_2}$'};
plot_info_p.grid_size = [2, 2];

% States plot
hfigs_speeds = my_plot(tspan, p, plot_info_p);

% Energies plot
hfig_energies = plot_energies(sys, tspan, x);
hfig_consts = plot_constraints(sys, tspan, x);

% Images
saveas(hfig_energies, '../images/energies', 'epsc');
saveas(hfigs_states(1), ['../images/states', num2str(1)], 'epsc'); 
saveas(hfigs_speeds(1), ['../images/speeds', num2str(1)], 'epsc'); 
saveas(hfig_consts(1), ['../images/consts', num2str(1)], 'epsc'); 
