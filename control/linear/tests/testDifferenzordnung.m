% %% Test Differenzordnung - Drei Tank
% clc
% clear
% 
% [A,B,C,D,~,~] = dreitank(0.2,0.1);
% sys = ss(A,B,C,D);
% 
% [d di] = differenzordnung(sys)
% 
% %% Test Differenzordnung - laufkatze
% clc
% clear
% 
% [A,B,C,D] = laufkatze();
% sys = ss(A,B,C,D);
% 
% [d di] = differenzordnung(sys)

% %% Test Differenzordnung - vorgestelltetes System
% clc
% clear
% 
% A = [-2 2 0; 2 -4 2; 0 2 -3];
% B = [0.5 0; 0 0; 0 0.5];
% C = [0 1 0; 0 0 1];
% D = [0 0; 0 0];
% sys = ss(A,B,C,D);
% 
% [d di] = differenzordnung(sys)

% %% Test Differenzordnung - Magnetschwebebahn
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
% [d di] = differenzordnung(sys)

% %% Test Differenzordnung - Boeing 747
% clc
% clear
% 
% A = [-0.0558 -0.9968 0.0802 0.0415;...
%       0.598 -0.115 -0.0318  0;...
%       -3.05 0.388 -0.465 0;...
%       0 0.0805 1 0];
% B = [0.00729 0.0583;...
%     -0.475 -2.01;...
%     0.153 0.0241;...
%     0 0];
% C = [1 0 0 0; 0 0 0 1   ];
% D = zeros(2,2);
% sys = ss(A,B,C,D);
% 
% [d di] = differenzordnung(sys)

%% Test Differenzordnung - System ohne Differenzordnung
clc
clear

A = [1 0; 0 1];
B = [1 0]';
C = [0 1];
D = 0;
sys = ss(A,B,C,D);

[d di] = differenzordnung(sys)

