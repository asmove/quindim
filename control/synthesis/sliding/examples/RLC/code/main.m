% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/RLC/code/main.m');

percs = [0.2];
switch_types = {'hyst'};
is_dyn_bound = false;

n_percs = length(percs);
n_switchs = length(switch_types);

for n_perc = 1:n_percs
    for n_switch = 1:n_switchs
        perc = percs(n_perc);
        switch_type = switch_types{n_switch};
        
        run('./RLC.m');
    end
end

