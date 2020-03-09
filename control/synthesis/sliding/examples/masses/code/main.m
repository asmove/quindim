% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/1_mass/code/main.m');

percs = [0; 0.1];
switch_types = {'poly'};
clear_inner_close_all();

n_percs = length(percs);
n_switchs = length(switch_types);

for n_perc = 1:n_percs
    for n_switch = 1:n_switchs
        perc = percs(n_perc);
        switch_type = switch_types{n_switch};
        
        run('./test_1_mass.m');
    end
end
% 
% run('~/github/Robotics4fun/examples/2_masses/code/main.m');
% 
% percs = [0, 0.5];
% is_sat_opts = [false, true];
% 
% for perc = percs
%     for is_sat = is_sat_opts
%         run('./test_2_masses.m');
%     end
% end
% 
