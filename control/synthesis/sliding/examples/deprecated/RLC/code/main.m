clear all
close all
clc

run('~/github/Robotics4fun/examples/RLC/code/main.m');

percs = [0];
switch_types = {'sat'};
clear_inner_close_all();

for perc = percs
    for switch_type = switch_types
        switch_type = switch_type{1};
        run('./RLC.m');
    end
end


