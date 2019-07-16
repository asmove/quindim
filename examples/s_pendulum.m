close all
clear all
clc

% The 'real' statement on end is important for inner simplifications
syms T m g Lg real;
syms th thp thpp real;

% Body inertia
I = sym(zeros(3, 3));
I(2, 2) = m*Lg^2;
I(3, 3) = m*Lg^2;

% Position relative to body coordinate system
L = [0; 0; Lg];

% Bodies transformations
Ts = {T3d(-pi/2, [0; 0; 1], [0; 0; 0]),
      T3d(th, [0; 0; 1], [0; 0; 0])};

% In this example is useless - The joint does no have friction
is_friction_linear = true;

% Previous body - Inertial, in this case
previous = struct('');

params = [];

pendulum = build_body(m, I, sym(0), Ts, L, th, thp, thpp, ...
                      is_friction_linear, previous, params);

