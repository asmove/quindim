% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/RLC/code/main.m');

phi_opts = [1];
is_sat_opts = [true];
is_imprecises = [true];

for phi = phi_opts
    for is_sat = is_sat_opts
        for is_imprecise = is_imprecises
            run('./RLC.m')
        end
    end
end

