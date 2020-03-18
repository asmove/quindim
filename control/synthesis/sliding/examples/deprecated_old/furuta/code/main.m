% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/furuta_pendulum/code/main.m');

percs = [0];
phi_opts = [10];
is_sat_opts = [false];    

for phi = phi_opts
    for is_sat = is_sat_opts
        for perc = percs
            run('./furuta.m')
        end
    end
end