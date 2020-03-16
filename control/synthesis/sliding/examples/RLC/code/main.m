% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/RLC/code/main.m');

except_names = {'sys', 'vars', ...
                'perc', 'switch_type', ...
                'is_dyn_bound', 'perc', ...
                'n_perc', 'n_percs', ...
                'n_switch', 'n_switchs', ...
                'is_dyn_bounds', 'switch_types', 'percs'};

percs = [0];
switch_types = {'sign'};
is_dyn_bound = false;

is_int = false;

n_percs = length(percs);
n_switchs = length(switch_types);

for n_perc = 1:n_percs
    for n_switch = 1:n_switchs
        perc = percs(n_perc);
        switch_type = switch_types{n_switch};
        
        run('./RLC.m');
        
        clean_vars(except_names);
        clear_inner_close_all('~/github/Robotics4fun');
        clear(func2str(@output_sliding));
        clear(output_sliding);
        clear(sliding_s);
    end
end

