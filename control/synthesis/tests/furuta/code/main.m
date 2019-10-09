% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/furuta_pendulum/code/main.m');

percs = [0, 0.1];
phi_opts = [1, 10, 100];
is_sat_opts = [true];    

for phi = phi_opts
    for is_sat = is_sat_opts
        for perc = percs
            run('./furuta.m')
        end
    end
end