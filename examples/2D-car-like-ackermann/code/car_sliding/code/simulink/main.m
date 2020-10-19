clear all
close all
clc

fig_handlers = findall(0,'type','figure','tag','TMWWaitbar');
delete(fig_handlers);

run('~/github/Robotics4fun/examples/2D-car-like-ackermann/code/main');
run('./init_vars.m');
run('./sim_blockdiagram.m');
run('./model_plot.m');


