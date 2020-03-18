% clear all
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/RLC/code/main.m');

% Keep variables from clear to continue simulation
except_names = {'sys', 'vars', ...
                'perc', 'switch_type', ...
                'is_dyn_bound', 'perc', ...
                'n_perc', 'n_percs', ...
                'n_switch', 'n_switchs', ...
                'is_dyn_bounds', 'switch_types', 'percs'};

% Simulation variations
percs = [0, 0.2];
switch_types = {'sign', 'sat', 'poly', 'hyst'};
is_ints = [true, false];

% XXX: Still deprecated for the current
is_dyn_bound = false;

% Plot results on simulation
is2sim = false;

n_percs = length(percs);
n_switchs = length(switch_types);
n_ints = length(is_ints);

control_laws =  {};

% Simulation scenarios
for n_perc = 1:n_percs
    for n_switch = 1:n_switchs
        for n_int = 1:n_ints
            perc = percs(n_perc);
            switch_type = switch_types{n_switch};
            is_int = is_ints(n_int);
            
            % Parameters on polynomial and current struct
            if(strcmp(switch_type, 'poly'))
                options = struct('degree', degree);
            else
                options = struct('');
            end
            
            run('./RLC.m');
            
            control_laws{end+1} = {{perc, switch_type, is_int}, ...
                                   u};
            
            if(is2sim)
                clean_vars(except_names);
                clear_inner_close_all('~/github/Robotics4fun');
                clear(func2str(@output_sliding));
            end
        end
    end
end

