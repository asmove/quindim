clear all
close all
clc

phi_opts = [1, 10, 100];
is_sat_opts = [true, false];

for phi = phi_opts
    for is_sat = is_sat_opts
        run('~/github/Robotics4fun/examples/RLC/code/main.m');
    end
end

