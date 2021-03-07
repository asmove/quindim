clear all
close all
clc

t0 = tic();
run('load_sym_model.m');
toc(t0);

t0 = tic();
run('load_num_model.m');
toc(t0);

% Controller poles
p_c_k = [-20; -25; -30];

% Observer poles
p_c_l = [-25; -30];

t0 = tic();
run('load_controller_observer.m');
toc(t0);
    
