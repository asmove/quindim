% Minimal example
% @Author: Bruno Peixoto

clear all
close all
clc

% The 'real' statement on end is important
% for inner simplifications
syms F x xp xpp m b g real;

% Paramater symbolics of the system
sys.syms = [m, b, g];

% Paramater symbolics of the system
sys.model_params = [1, 0.1, 9.8];

% Gravity utilities
sys.gravity = [0; 0; -g];
sys.g = g;

% Body inertia
I = zeros(3, 3);

% Position relative to body coordinate system
L = zeros(3, 1);

% Bodies definition
T = {T3d(0, [0, 0, 1].', [x; 0; 0])};

block = build_body(m, I, b, T, L, ... 
                   x, xp, xpp, ...
                   true, struct(''), []);

sys.bodies = block;

% Generalized coordinates
sys.q = x;
sys.qp = xp;
sys.qpp = xpp;

% Generalized coordinates
sys.p = xp;
sys.pp = xpp;

% External excitations
sys.Fq = F;
sys.u = F;

% Constraint condition
sys.is_constrained = false;

% Sensors
sys.y = x;

% State space representation
sys.states = [x; xp];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Decay time
m_num = sys.model_params(1);
b_num = sys.model_params(2);
T = m_num/b_num;

% n time constants decay
n = 3;
decay_percentual = 1 - exp(-n);

% Time [s]
dt = 0.01;
tf = -T*log(1 - decay_percentual);
t = 0:dt:tf; 

% Initia conditions [m; m/s]
x0 = [0; 1];

% System modelling
sol = validate_model(sys, t, x0, 0);

x = sol.x;
y = sol.y.';

titles = {'$x$', '$\dot x$'};
xlabels = {'$t$ [s]', '$t$ [s]'};
ylabels = {'$x$ [m]', '$\dot x$ [m/s]'};

plot_states(x, y, titles, xlabels, ylabels)

