clear all
close all
clc

run('~/github/Robotics4fun/examples/gyroscope/code/main.m');

percs = [0 0.5];
is_sat_opts = [false, true];

for perc = percs
    for is_sat = is_sat_opts
        run('./gyroscope_control.m');
    end
end