    %% Test Polvorgabe - Drei Tank
clc
clear

A = [-2.0087 2.0087 0; 2.0087 -4.017 2.0087; 0 2.0087 -2.6648];
B = [0.3898 0; 0 0; 0 0.3898];
C = [0 1 0; 0 0 1];
D = zeros(2,2);
sys = ss(A,B,C,D);

[n,p] = size(B);
[q,n] = size(C);

[d di] = differenzordnung(sys);
ew = {[-1 -2] -3};
[R,F] = entkopplungFalb(sys,ew);

% %% Test Polvorgabe - vorgestelltetes System
% clc
% clear
% 
% A = [0 0 1 0; 0 0 0 1; 0 9.3195 0 0; 0 -6.3765 0 0];
% B = [0 0 1/20 -1/60]';
% C = [1 0 0 0];
% D = 0;
% sys = ss(A,B,C,D);
% 
% [n,p] = size(B);
% [q,n] = size(C);
% 
% [d di] = differenzordnung(sys)
% ew = {[-1 -2]};
% [R,F] = entkopplungFalb(sys,ew)