clear all
close all
clc

syms m Iyz Ixz Iz;

syms Xup Yup Nup;
syms Xvp Yvp Nvp;
syms Xrp Yrp Nrp;

syms Xu;
syms Yv Yr;
syms Nv Nr;

syms yg xg 
syms Xuu;

syms Yvv Yrv Yvr Yrr;
syms Nvv Nrv Nvr Nrr;

syms tau_x tau_y tau_psi;
syms up vp rp;
syms u v r;
syms x y th;

% Mass matrices
Ma = [m, 0, -m*yg; 0, m, m*xg; -m*yg, m*xg, Iz];
Mrb = -[Xup, Xvp, Xrp; Yup, Yvp, Yrp; Yup, Yvp, Yrp];

M = Ma + Mrb;

% Centrifugal matrices
Crb = [0, 0, -m*(xg*r + v); 0, 0, m*(yg*r - u); -Iyz*r, Ixz*r, 0];

a1 = Xup*u + Xvp*v + Xrp*r;
a2 = Yup*u + Yvp*v + Yrp*r;
Ca = [0, 0, a2; 0, 0, -a1; -a2, a2, 0];

C = Crb + Ca;

% Damping matrices
D = -[Xu, 0, 0; 0, Yv, Yr; 0, Nv, Nr];
Dn = [Xuu*abs(u), 0, 0; ...
      0, Yvv*abs(v) + Yrv*abs(r), Yvr*abs(v) + Yrr*abs(r); 
      0, Nvv*abs(v) + Nrv*abs(r), Nvr*abs(v) + Nrr*abs(r)];

Dv = D + Dn;

sys.dyn.H = M;
sys.dyn.h = (C + D)*[u; v; r];
sys.dyn.Z = eye(3);

sys.kin.C = {eye(3)};
sys.kin.Cp = {zeros(3)};

sys.kin.q = [x; y; th];
sys.kin.p = {[u; v; r]};
sys.kin.pp = {[up; vp; rp]};

sys.descrip.syms = [m Iyz Ixz Iz, ...
                    Xup Yup Nup Xvp Yvp Nvp Xrp Yrp Nrp, ...
                    Xu Yv Yr Nv Nr, ...
                    yg xg Xuu Yvv Yrv Yvr Yrr Nvv Nrv Nvr Nrr];

% sys.descrip.model_params = [90784 0 0 300154600, ...
%                             11055.84481 0 0 ...
%                             0 44000.05845 0 ...
%                             0 0 314807940.4, ...
%                             0 0 0 0 0, ...
%                             1 1 -19.1 -1.904e5 2.087e7 3.704e6 8.779e8...
%                             -7.769e6 5.9e10 3.279e7 5.9e10];

sys.descrip.model_params = rand(1, length(sys.descrip.syms));

perc = 10/100;
is_sat = false;
                
model_params = sys.descrip.model_params.';
imprecision = perc*ones(size(sys.descrip.syms))';
params_lims = [(1-imprecision).*model_params, ...
               (1+imprecision).*model_params];

rel_qqbar = sys.kin.q;

[~, m] = size(sys.dyn.Z);
phi = 1;

% Control action
eta = 50*ones(m, 1);
poles = -10*ones(m, 1);
u = sliding_underactuated(sys, eta, poles, ...
                          params_lims, rel_qqbar, is_sat);
