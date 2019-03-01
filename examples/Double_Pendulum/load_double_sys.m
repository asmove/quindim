% @Author: Bruno Peixoto
% @Date: 08/11
clear all;
close all;
clc;

% Time delays for the system
ndelay = 1;

% Sample time for the system
Ts = 1/100;

% Plant parameters
sys = double_pendulum(Ts, ndelay);

run('load_lqg');