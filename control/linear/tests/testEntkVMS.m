% %% Test Polvorgabe - Drei Tank
% clc
% clear
% 
% A = [-2.0087 2.0087 0; 2.0087 -4.017 2.0087; 0 2.0087 -2.6648];
% B = [0.3898 0; 0 0; 0 0.3898];
% C = [0 1 0; 0 0 1];
% D = zeros(2,2);
% sys = ss(A,B,C,D);
% 
% [n,p] = size(B);
% [q,n] = size(C);
% 
% [d di] = differenzordnung(sys)
% ew = {{-1 -2} {-3}};
% [R,F] = entkopplungVMS(sys,ew)

%% Test Polvorgabe - vorgestelltetes System
clc
clear

% Zustandsraumdarstellung
A = [-0.0558 -0.9968 0.0802 0.0415;...
      0.598 -0.115 -0.0318  0;...
      -3.05 0.388 -0.465 0;...
      0 0.0805 1 0];
B = [0.00729 0.0583;...
    -0.475 -2.01;...
    0.153 0.0241;...
    0 0];
C = [1 0 0 0; 0 0 0 1   ];
D = zeros(2,2);
sys = ss(A,B,C,D);

[n,p] = size(B);
[q,n] = size(C);

[d di] = differenzordnung(sys)
ew = {{-0.5} {-0.5+1j -0.5-1j}};
[R,F] = entkopplungVMS(sys,ew)