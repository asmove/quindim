% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/RLC/code/main.m');

percs = 0;
switch_types = {'sign'};
is_dyn_bounds = false;

n_percs = length(percs);
n_switchs = length(switch_types);

for n_perc = 1:n_percs
    for n_switch = 1:n_switchs
        perc_ = percs(n_perc);
        switch_type = switch_types{n_switch};
        
        if(strcmp(switch_type, 'sat') || strcmp(switch_type, 'poly'))
            for is_dyn_bound = is_dyn_bounds
                run('./RLC.m');
            end
        else
            is_dyn_bound = false;
            run('./RLC.m');
        end
    end
end

