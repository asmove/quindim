clear all
clc

syms T;

A = eig_to_matrix([-1, -2, -3]);
C = [1, 1, 1];

phi_ = exp(A*T);
gamma_ = C;

Mo = obsv_k(phi_, C);

Ts0 = 0.1;
n = length(A);

Ts_prev = 0;
Ts_curr = Ts0;

ERROR = 1e-10;
THRESHOLD = 1000;

is_end = false;

while ~is_end
    Mo_ = subs(Mo, T, Ts_curr);
    
    if(rank(Mo_) < n)
        temp = Ts_curr;
        Ts_curr = (Ts_curr + Ts_prev)/2;
        Ts_prev = temp;
    else
        temp = Ts_curr;
        Ts_curr = 2*Ts_curr;
        Ts_prev = temp;
    end
    
    if((Ts_curr > THRESHOLD) || ...
       (abs(Ts_curr - Ts_prev) < ERROR))
        is_end = true;
    end
end

disp(sprintf('Loss of observbility for %.2f', Ts_curr));
