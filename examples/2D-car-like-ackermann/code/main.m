% Author: Bruno Peixoto
% Date: 08/01/19
if(~exist('CLEAR_ALL'))
    clear all;
else
    if(CLEAR_ALL)
        clear all
    end
end

SIM_SYS = true;

close all
clc

syms g f_phi_i f_phi_o f_phi_r f_phi_l;

% Body 1
syms mc mi mo mr ml R real;
syms w L real;

syms w Lc Li Lo Lr Ll real;

syms xi_g yi_g real;
syms xo_g yo_g real;
syms xr_g yr_g real;
syms xl_g yl_g real;
syms xc_g yc_g real;

syms x_pos y_pos theta delta_i delta_o phi_i phi_o phi_r phi_l real;
syms xp yp thetap deltap_i deltap_o phip_i phip_o phip_r phip_l real;
syms xpp ypp thetapp deltapp_i deltapp_o phipp_i phipp_o phipp_r phipp_l real;

I_i = inertia_tensor('i', false);
I_o = inertia_tensor('o', false);
I_r = inertia_tensor('r', false);
I_l = inertia_tensor('l', false);
I_c = inertia_tensor('c', false);

% Rotations to body
% Hypothesis: Symmetric car
Tc = T3d(theta, [0; 0; 1], [x_pos; y_pos; 0]);
Ti = T3d(delta_i, [0; 0; 1], [-w/2; L; 0]);
To = T3d(delta_o, [0; 0; 1], [w/2; L; 0]);
Tr = T3d(0, [0; 0; 1], [-w/2; 0; 0]);
Tl = T3d(0, [0; 0; 1], [w/2; 0; 0]);

Tcs = {Tc};
Tis = {Tc, Ti};
Tos = {Tc, To};
Trs = {Tc, Tr};
Tls = {Tc, Tl};

Ts = {{Tc}, ...
      {Tc, Ti}, {Tc, To}, ...
      {Tc, Tr}, {Tc, Tl}};

% Generalized coordinates
sys.kin.q = [x_pos; y_pos; theta; ...
             delta_i; delta_o; ...
             phi_i; phi_o; phi_r; phi_l];
sys.kin.qp = [xp; yp; thetap; ...
              deltap_i; deltap_o; ...
              phip_i; phip_o; phip_r; phip_l];
sys.kin.qpp = [xpp; ypp; thetapp; ...
               deltapp_i; deltapp_o; ...
               phipp_i; phipp_o; phipp_r; phipp_l];

run('./load_bodies.m');
run('./load_params.m');

% External excitations
sys.descrip.Fq = [0; 0; 0; 0; 0; ...
                  f_phi_i; f_phi_o; f_phi_r; f_phi_l];

sys.descrip.u = [f_phi_i; f_phi_o; f_phi_r; f_phi_l];

% State space representation
sys.descrip.states = [x_pos; y_pos; theta; delta_i; delta_o; ...
                      phi_i; phi_o; phi_r; phi_l];

% Quick hack: Obtain unconstrained velocity of each wheel 
sys.descrip.is_constrained = false;
sys = kinematic_model(sys);

% Constraint condition
sys.descrip.is_constrained = true;

run('./consts_gen.m');

% Kinematic and dynamic model
sys = kinematic_model(sys);

% Holonomic expression
delta_o_expr = atan(L*tan(tan(delta_i)/(L + w*tan(delta_i))));
sys.kin.A = subs(sys.kin.A, delta_i, delta_o_expr);
sys.kin.C = subs(sys.kin.C, delta_i, delta_o_expr);

sys = dynamic_model(sys);

run('./sim_system.m');