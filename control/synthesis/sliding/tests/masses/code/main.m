% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/1_mass/code/main.m');

percs = [0];
switch_types = {'sign '};
clear_inner_close_all();

for perc = percs
    for switch_type = switch_types
        switch_type = switch_type{1};
        run('./test_1_mass.m');
    end
end

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
