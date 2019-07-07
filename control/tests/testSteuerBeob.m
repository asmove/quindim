%% Test Beobachtbarkeit und Steuerbarkeit - Drei Tank
clc
clear

[A,B,C,D,~,~] = dreitank(0.2,0.1);
sys = ss(A,B,C,D);

ctb = steuerbarKalman(sys);
ctb = beobachtbarKalman(sys);

[ctb,ew] = steuerbarHautus(sys)
[ctb,ew] = beobachtbarHautus(sys)

[ctb,ew] = steuerbarGilbert(sys)
[ctb,ew] = beobachtbarGilbert(sys)

% %% Test Beobachtbarkeit und Steuerbarkeit - laufkatze
% clc
% 
% [A,B,C,D] = laufkatze();
% sys = ss(A,B,C,D);
% 
% ctb = steuerbarKalman(sys);
% ctb = beobachtbarKalman(sys);
% 
% [ctb,ew] = steuerbarHautus(sys)
% [ctb,ew] = beobachtbarHautus(sys)
% 
% [ctb,ew] = steuerbarGilbert(sys)
% [ctb,ew] = beobachtbarGilbert(sys)

% %% Test Beobachtbarkeit und Steuerbarkeit - vorgestelltetes System
% clc
% 
% A = diag([-1 -1 -2]);
% B = [1 1; 2 2; 1 2];
% C = [1 0 0];
% D = [0 0];
% sys = ss(A,B,C,D);
% 
% ctb = steuerbarKalman(sys);
% ctb = beobachtbarKalman(sys);
% 
% [ctb,ew] = steuerbarHautus(sys)
% [ctb,ew] = beobachtbarHautus(sys)
% 
% [ctb,ew] = steuerbarGilbert(sys)
% [ctb,ew] = beobachtbarGilbert(sys)
