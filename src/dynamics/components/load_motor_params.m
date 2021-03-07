clear all
close all
clc

run('./tests/utils/load_pwm_delayed_pred_noised_controller.m');

step_ref = torque_ref;

tf = 5;

x0 = [0; 0];
xhat0 = [0; 0];

n_i = sum(params.nds_i);

u0 = 0;
e0 = step_ref;

simOut = sim('motor.slx', ...
             'SolverType','Variable-step', ...
             'SaveOutput','on',...
             'OutputSaveName','youtNew');

output = simOut.output;         

time = output.time;
torque = output.signals.values;

plot(time, torque);

