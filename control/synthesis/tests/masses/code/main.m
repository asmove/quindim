clear all
close all
clc

run('~/github/Robotics4fun/examples/1_mass/code/main.m');

percs = [0, 0.5];
is_sat_opts = [false, true];

for perc = percs
    for is_sat = is_sat_opts
        run('./test_1_mass.m');
    end
end

run('~/github/Robotics4fun/examples/2_masses/code/main.m');

for perc = perc
    for is_sat = is_sat_opts
        run('./test_2_masses.m');
    end
end

