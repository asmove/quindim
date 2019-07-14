%% Test Polvorgabe - Drei Tank
clc
clear

[A,B,C,D,~,~] = dreitank(0.2,0.1);
sys = ss(A,B,C,D);

[n,p] = size(B);
[q,n] = size(C);

P = rand(p,n);
ew = [-0.5 -1 -1.5];

[R F] = VMS(sys,ew,P);

% %% Test Polvorgabe - laufkatze
% clc
% clear 
% 
% [A,B,C,D] = laufkatze();
% sys = ss(A,B,C,D);
% 
% [n,p] = size(B);
% [q,n] = size(C);
% 
% P = rand(p,n);
% ew = [-0.5 -1 -1.5 -2];
% 
% [R F] = VMS(sys,ew,P);

% %% Test Polvorgabe - vorgestelltetes System
% clc
% clear
% 
% A = [-2 2 0; 2 -4 2; 0 2 -3];
% B = [0.5 0; 0 0; 0 0.5];
% C = [0 1 0; 0 0 1];
% D = [0 0; 0 0];
% sys = ss(A,B,C,D);
% 
% [n,p] = size(B);
% [q,n] = size(C);
% 
% % P = [1 1 0; 1 0 1];
% P = [1 0 1; 1 1 0];
% ew = [-7 -3 -1];
% 
% [R F] = VMS(sys,ew,P);

% %% Test Polvorgabe - Magnetschwebebahn
% clc
% clear
% 
% A = [0 0 1 0 0; 0 0 0 1 0;...
%     -50.67 50.67 -4.9 4.9 -2.26e-3;...
%     25.25 -25.25 2.44 -2.44 0;...
%     -6.4e6 0 2.1e5 0 -3.26];
% B = [0 0 0 0 -1440]';
% C = [0 0 0 0 1];
% D = 0;
% sys = ss(A,B,C,D);
% 
% ew = eig(A);
% ew(3) = -16;
% 
% [n,p] = size(B);
% [q,n] = size(C);
% 
% [R F] = VMS(sys,ew)