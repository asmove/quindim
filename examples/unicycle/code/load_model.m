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
