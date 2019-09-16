clear all
close all
clc

run('~/github/Robotics4fun/examples/1_mass/code/main.m');

perc = 0;
run('./test_1_mass.m');

perc = 50/100;
run('./test_1_mass.m');