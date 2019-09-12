clear all
close all
clc

perc = 0;
run('./test_1_mass.m');

perc = 50/100;
run('./test_1_mass.m');

perc = 0;
run('./test_2_masses.m');

perc = 50/100;
run('./test_2_masses.m');