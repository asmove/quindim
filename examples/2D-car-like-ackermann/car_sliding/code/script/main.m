clear all
close all
clc

fig_handlers = findall(0,'type','figure','tag','TMWWaitbar');
delete(fig_handlers);

run('~/github/Robotics4fun/examples/2D-car-like-ackermann/code/main');

run([pwd, '/model_simulation']);
run([pwd, '/model_plot']);


